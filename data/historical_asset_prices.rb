require "stock_quote"

 StockQuote::Stock.new(api_key: "pk_fc4bf13336e54aa8b8a63f36d3cd05f0")

 # amzn = StockQuote::Stock.quote('amzn')
# p amzn.company_name
# p amzn.latest_price
# p amzn.latest_source
# p amzn.ytd_change
# p amzn.iex_realtime_price


 # amzn_dividends = StockQuote::Stock.dividends('amzn')
 # p amzn_dividends
 # amzn = StockQuote::Stock.quote("amzn", 4/15/2020)
 amzn = StockQuote::Stock.quote('amzn', '1d')
 p amzn.latest_price
