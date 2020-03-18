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

  output[0..-2]
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
  url = 'https://www.marketwatch.com/investing/index/spx/historical'
  html = open(url)
  doc = Nokogiri::HTML(html)


  previous_close = doc.css('.quotedisplay.tenwidequote .prevclose .price')
  just_content = previous_close.map do |data|
    data.content.strip
  end

  str = just_content[0]
  no_comma = str.gsub(/,/, '')
  no_comma.to_f.round(2)
end










