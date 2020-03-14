require "sinatra"
require "sinatra/content_for"
require "tilt/erubis"
require_relative "database_persistence"
require "stock_quote"

configure(:development) do
  require "sinatra/reloader"
  also_reload "database_persistence.rb"
end

before do
  @storage = DatabasePersistence.new(logger)
end

after do
  @storage.disconnect
end

get "/" do
  erb :layout
end

get "/addposition" do 
  erb :addposition, layout: :blank
end

post "/addposition" do
  @all_params = params
  erb :didwegetit, layout: :blank
end

StockQuote::Stock.new(api_key: "pk_fc4bf13336e54aa8b8a63f36d3cd05f0")

amzn = StockQuote::Stock.quote('amzn')
p amzn.company_name
p amzn.latest_price
p amzn.latest_source
p amzn.ytd_change

puts

appf = StockQuote::Stock.quote('appf')
p appf.company_name
p appf.latest_price
p appf.latest_source
p appf.ytd_change

puts

vfiax = StockQuote::Stock.quote('vfiax')
p vfiax.company_name
p vfiax.latest_price
p vfiax.latest_source
p vfiax.ytd_change