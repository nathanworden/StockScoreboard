require "sinatra"
require "sinatra/content_for"
require "tilt/erubis"
require_relative "database_persistence"
require "stock_quote"

configure(:development) do
  require "sinatra/reloader"
  also_reload "database_persistence.rb"
end

def pull_market_data(all_positions)
  all_positions.each do |stock|
    stock[:current_data] = StockQuote::Stock.quote(stock[:ticker])
    stock[:one_day_change] = (stock[:current_data].change_percent * 100).round(2)
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
  all_positions = @storage.get_all_positions
  @all_positions = pull_market_data(all_positions)

  # "#{@storage.get_all_positions}"
  erb :stock_table, layout: :layout
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