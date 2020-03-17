require "sinatra"
require "sinatra/content_for"
require "tilt/erubis"
require_relative "database_persistence"
require "stock_quote"
require 'rbconfig'
require_relative "./data/s_and_p_data/scrape_todays_s_and_p.rb"

configure(:development) do
  require "sinatra/reloader"
  also_reload "database_persistence.rb"
end

def pull_market_data(all_positions, total_portfolio_amount)
  all_positions.each do |stock|
    stock[:current_data] = StockQuote::Stock.quote(stock[:ticker])
    stock[:one_day_change] = (stock[:current_data].change_percent * 100).round(2)
    stock[:return_dollars] = ((stock[:current_data].latest_price - stock[:purchase_price].to_f) * stock[:shares]).round(2)
    stock[:return_percent] = ((stock[:current_data].latest_price - stock[:purchase_price].to_f) / stock[:purchase_price].to_f * 100).round(2)
    stock[:cost_basis] = (stock[:purchase_price] * stock[:shares]).round(2)
    stock[:percent_portfolio] = ((stock[:cost_basis] / total_portfolio_amount) * 100).round(2)
    stock[:market_value] = ((stock[:current_data].latest_price * stock[:shares])).round(2)
    stock[:pe_ratio] = stock[:current_data].pe_ratio
    stock[:sandp_on_purchase_date] = stock[:purchase_date] #@storage.get_historical_sandp(stock[:purchase_date])
  end
end

before do
  @storage = DatabasePersistence.new(logger)
  StockQuote::Stock.new(api_key: "pk_fc4bf13336e54aa8b8a63f36d3cd05f0")
end

after do
  @storage.disconnect
end

get "/" do
  # all_positions = @storage.get_all_positions
  # total_portfolio_amount = @storage.get_full_portfolio_amount
  # @all_positions = pull_market_data(all_positions, total_portfolio_amount)
  # @todays_sp_percent = todays_sp_percent
  # @todays_sp_points = todays_sp_points


  "#{@storage.add_yesterday_sandp}"
  # erb :stock_table, layout: :layout
end

get "/addposition" do 
  erb :addposition, layout: :blank
end

post "/addposition" do
  @all_params = params
  @storage.add_position(params["ticker"], params["shares"], params["purchase-date"], params["purchase-price"], params["comission"])
  # erb :didwegetit, layout: :blank
  redirect "/"
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