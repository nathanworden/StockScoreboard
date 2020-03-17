require 'open-uri'
require 'nokogiri'
require 'json'


def todays_sp_points
  url = 'https://www.cnbc.com/quotes/?symbol=.SPX'
  html = open(url)
  doc = Nokogiri::HTML(html)

  element =  doc.css('.quote-custom-strip .quote-horizontal span.last.original')

  output = ''

  element.search('span').each do |span|
    output += span.content
  end

  output
end


def todays_sp_percent
  url = 'https://www.cnbc.com/quotes/?symbol=.SPX'
  html = open(url)
  doc = Nokogiri::HTML(html)

  content_of_spans = []
  element = doc.css('.quotestrip .quote-custom-strip .quote-horizontal .change span')

  element.search('span').each do |span|
    content_of_spans << span.content
  end

  pt_change, percent_change = content_of_spans.select {|ele| ele.include?('.')}
  percent_change
end

def yesterday_sp_close
  url = 'https://finance.yahoo.com/quote/%5EGSPC/history?period1=-1325635200&period2=1584403200&interval=1d&filter=history&frequency=1d'
  html = open(url)
  doc = Nokogiri::HTML(html)
end













