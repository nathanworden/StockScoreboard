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
  @error = session[:error]

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

  @holding_period_return = ((@total_current_portfolio_market_value / @storage.previous_portfolio_value_after_cash_flow) - 1)
  @time_weighted_return_to_date = (((1 + @holding_period_return) * (1 + @storage.previous_time_weighted_return / 100) - 1) * 100).round(2)

  # "holding period return: #{@holding_period_return}  previous time weighed return: #{@storage.previous_time_weighted_return}  #{@time_weighted_return_to_date}"

  update_stocks_percent_portfolio(@all_positions, @total_current_portfolio_market_value)
  @all_positions = order_all_positions_by(@storage.table_sort_rule)

  session[:error] = nil

  erb :stock_table, layout: :layout
end

get "/addposition" do 
  @error = session[:error]
  # erb :addposition, layout: :blank
  erb :stock_table, layout: :layout
end

post "/addposition" do
  @all_params = params
  @all_params["commission"] = 0 if @all_params["commission"] == ""
  @all_params["purchase-price"] = @all_params["purchase-price"].gsub(/[^\d\.]/, '')
  @all_params["ticker"] = @all_params["ticker"].upcase

  if !params["purchase-date"].match(/\d{1,2}\/\d{1,2}\/\d{4}/)
    session[:error] = "Purchase Date must be in format: mm/dd/yyyy"
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

# Example of calls you can make with StockQuote gem:

# amzn = StockQuote::Stock.quote('amzn')
# p amzn.company_name
# p amzn.latest_price
# p amzn.latest_source
# p amzn.ytd_change
