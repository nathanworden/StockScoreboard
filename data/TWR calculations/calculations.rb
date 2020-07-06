# require "stock_quote"
require 'rest-client'
require 'json'

module StockQuote
  class Stock
    URL = "https://cloud.iexapis.com/stable/stock/market/batch?symbols=aal,f,rcl,xom,eog,ccl,dis,wynn,nly,pru&format=json&types=quote&token=pk_fc4bf13336e54aa8b8a63f36d3cd05f0"
    # URL = "https://cloud.iexapis.com/stable/stock/market/batch?"

    def self.request
      RestClient::Request.execute(:url => URL, :method => :get) do |response|
        response
      end
    end
  end
end
 
batch =  StockQuote::Stock.request
json_batch = JSON.parse(batch.body)
p json_batch['CCL']






# StockQuote::Stock.new(api_key: "pk_fc4bf13336e54aa8b8a63f36d3cd05f0")


# amzn = StockQuote::Stock.quote('amzn')
# p amzn.company_name
# p amzn.latest_price
# p amzn.latest_source
# p amzn.ytd_change