require 'rubygems'
require 'nokogiri'
require 'open-uri'

url = "http://www1.toronto.ca/parks/prd/facilities/complex/2012/"
doc = Nokogiri::HTML(open(url))
puts doc.at_css("title").text
puts week_0 = doc.at_css("#dropin_Swimming_0").text
puts week_1 = doc.at_css("#dropin_Swimming_1").text
