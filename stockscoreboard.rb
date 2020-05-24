require "sinatra"
require "sinatra/content_for"
require "tilt/erubis"
require_relative "database_persistence"
require "stock_quote"
require 'rbconfig'
require_relative "./data/s_and_p_data/scrape_todays_s_and_p.rb"
require 'date'
# require 'alpaca/trade/api'

configure(:development) do
  require "sinatra/reloader"
  also_reload "database_persistence.rb"
  enable :sessions
  set :session_secret, 'secret'
end

before do
  @storage = DatabasePersistence.new(logger)
  StockQuote::Stock.new(api_key: "pk_fc4bf13336e54aa8b8a63f36d3cd05f0")
  @storage.add_yesterday_sandp(yesterday_sp_close)
end

def pos_or_neg(value)
  value.to_f >= 0 ? "pos" : "neg"
end

# def pull_batch_market_data(all_positions)                 # This was an experiment to try and see if it was possible to get the page to load faster by batching the requests all into one rather than doing them one by one. Eyeballing it it didn't seem to improve the speed. Experiemnt done on 5.14.20
#   output = []
#   all_positions.each {|stock| output << stock[:ticker]}
#   stock_objects = StockQuote::Stock.quote(output)
#   stock_objects.map {|stock| stock.latest_price}
# end

def pull_market_data(all_positions, total_portfolio_cost_basis)
  @total_current_portfolio_market_value = 0
  @previous_day_portfolio_market_value = 0

  all_positions.each do |stock|
    stock[:current_data] = StockQuote::Stock.quote(stock[:ticker])
    stock[:previous_close] = stock[:current_data].previous_close
    stock[:latest_price] = get_latest_price(stock)
    stock[:one_day_change] = (stock[:current_data].change_percent * 100).round(2)
    stock[:return_dollars] = ((stock[:current_data].latest_price - stock[:purchase_price].to_f) * stock[:shares]).round(2)
    stock[:return_percent] = ((stock[:current_data].latest_price - stock[:purchase_price].to_f) / stock[:purchase_price].to_f * 100).round(2)
    stock[:cost_basis] = (stock[:purchase_price] * stock[:shares]).round(2)
    # stock[:percent_portfolio] = ((stock[:cost_basis] / total_portfolio_cost_basis) * 100).round(2)
    stock[:market_value] = ((stock[:current_data].latest_price * stock[:shares])).round(2)
    @total_current_portfolio_market_value += stock[:market_value]
    @previous_day_portfolio_market_value += stock[:previous_close] * stock[:shares]
    stock[:pe_ratio] = stock[:current_data].pe_ratio
    # stock[:return_vs_sandp] =  (stock[:return_percent] - calculate_sandp_on_purchase_date(stock)).round(2)


    stock[:return_vs_sandp] =  (stock[:return_percent] - s_and_p_return_since_stock_purchase_date(stock)).round(2)
  end
end

def update_stocks_percent_portfolio(all_positions, total_current_portfolio_market_value)
  all_positions.each do |stock|
      stock[:percent_portfolio] = ((stock[:market_value] / total_current_portfolio_market_value) * 100).round(2)
  end
end

def get_latest_price(stock)
  (stock[:current_data].latest_price).round(2)
end

def format_num(num, include_dollar_sign='include_dollar_sign')
  dollar_sign = include_dollar_sign == 'no_dollar_sign' ? '' : '$'
  negative = num.to_f < 0 ? true : false
  num = num.to_f.abs
  converted = num.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  if negative
    '-' + dollar_sign + converted
  else
    dollar_sign + converted
  end
end

def s_and_p_return_since_stock_purchase_date(stock)
  ((todays_sp_points.to_f - stock[:s_and_p_at_stock_purchase_date]) / stock[:s_and_p_at_stock_purchase_date] * 100)
end

# def calculate_sandp_on_purchase_date(stock)
#   datestr = create_date_str
#   if stock[:purchase_date] == datestr
#     todays_sp_percent.to_f
#   else
#     sandp_at_time_of_stock_purchase = @storage.get_historical_sandp(stock[:purchase_date])[0].to_f
#     (((todays_sp_points.to_f - sandp_at_time_of_stock_purchase) / sandp_at_time_of_stock_purchase) * 100).round(2)
#   end
# end

# def create_date_str
#   date = Date.today
#   month = date.mon.to_s
#   monthday = date.mday.to_s
#   month.length == 1 ? month = "0" + month : month
#   monthday.length == 1 ? monthday = "0" + month : monthday
#   "#{date.year}-#{month}-#{monthday}"
# end

def order_all_positions_by(rule)
  @all_positions.sort_by! do |stock|
    stock[rule]
  end
end

after do
  @storage.disconnect
end

post "/" do
  @storage.update_table_sort_rule(params.keys[0])
  redirect "/"
end

get "/" do
  all_positions = @storage.get_all_positions
  @total_portfolio_cost_basis = @storage.get_full_portfolio_cost_basis
  @all_positions = pull_market_data(all_positions, @total_portfolio_cost_basis)

  @todays_sp_percent = todays_sp_percent
  @todays_sp_points = todays_sp_points
  @total_current_portfolio_market_value = @total_current_portfolio_market_value.round(2)
  @one_day_change_dollars = (@total_current_portfolio_market_value - @previous_day_portfolio_market_value).round(2)
  @one_day_change_percent = (@one_day_change_dollars / @previous_day_portfolio_market_value * 100).round(2)
  @total_portfolio_returns_in_dollars = @total_current_portfolio_market_value - @total_portfolio_cost_basis
  @total_portfolio_returns_percent = @total_portfolio_returns_in_dollars / @total_portfolio_cost_basis

  update_stocks_percent_portfolio(@all_positions, @total_current_portfolio_market_value)
  @all_positions = order_all_positions_by(@storage.table_sort_rule)

  session[:error] = nil

  erb :stock_table, layout: :layout
end

get "/addposition" do 
  @error = session[:error]
  erb :addposition, layout: :blank
end

post "/addposition" do
  @all_params = params
  @all_params["commission"] = 0 if @all_params["commission"] == ""
  @all_params["purchase-price"] = @all_params["purchase-price"].gsub(/[^\d\.]/, '')
  @all_params["ticker"] = @all_params["ticker"].upcase

  if !params["purchase-date"].match(/\d{1,2}\/\d{1,2}\/\d{4}/)
    session[:error] = "Purchase Date must be in this format: mm/dd/yyy"
    redirect "/addposition"
  end

  if Date.strptime(@all_params["purchase-date"], '%m/%d/%Y') == Date.today
    s_and_p_at_stock_purchase_date = todays_sp_points
  else
    s_and_p_at_stock_purchase_date = @storage.get_sandp_on(@all_params["purchase-date"])
  end
  @storage.add_position(@all_params["ticker"], params["shares"], params["purchase-date"], params["purchase-price"], params["commission"], s_and_p_at_stock_purchase_date)
  # erb :didwegetit, layout: :blank
  redirect "/"
end


post "/delete-position/:id" do
  @storage.delete_position(params[:id])
  redirect "/"
end

post "/edit-position/:ticker" do
  @position = @storage.get_position(params[:ticker])
  # @ticker = position[:ticker]
  # @shares = position[:shares]
  # @purchase_date = position[:purchase_date]


  erb :addposition, layout: :blank
end



# amzn = StockQuote::Stock.quote('amzn')
# p amzn.company_name
# p amzn.latest_price
# p amzn.latest_source
# p amzn.ytd_change

# puts

# appf = StockQuote::Stock.quote('appf')
# p appf.company_name
# p appf.latest_price
# p appf.latest_source
# p appf.ytd_change

# puts

# vfiax = StockQuote::Stock.quote('vfiax')
# p vfiax.company_name
# p vfiax.latest_price
# p vfiax.latest_source
# p vfiax.ytd_change