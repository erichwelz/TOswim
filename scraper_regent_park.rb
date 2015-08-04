require 'nokogiri'
require 'open-uri'
require 'pry'

url = "http://www1.toronto.ca/parks/prd/facilities/complex/2012/"
doc = Nokogiri::HTML(open(url))

week_0 = doc.at_css("#dropin_Swimming_0").text
#week_1 = doc.at_css("#dropin_Swimming_1").text

week_0_dates = []
doc.at_css("#dropin_Swimming_0 tr").children
                                   .each_with_index { |el, i| week_0_dates[i] = el.text }

lane_swim_row_index = doc.at_css("#dropin_Swimming_0 tbody").css('tr')
                      .find_index { |el| el.text=~ /Lane Swim/ }

week_0_lane_swim_times = []

doc.at_css("#dropin_Swimming_0 tbody").css('tr')[lane_swim_row_index].children
   .each_with_index do |el, i|
                      nodes = el.children.find_all{ |x| x.text? }
                      if nodes.length == 1
                        nodes = el.children.text
                      else
                        nodes.map{ |x| x.text }
                      end
                        week_0_lane_swim_times[i] = nodes
                    end

#remove empty index 0's
week_0_dates.shift
week_0_lane_swim_times.shift

week_0_info = week_0_dates.zip(week_0_lane_swim_times)

puts week_0_info

## Todo
# loop for multiple weeks
# build a hash
#capture pool lists

#Indoor pools list: http://www1.toronto.ca/parks/prd/facilities/outdoor-pools/index.htm
#Outdoor pools list: http://www1.toronto.ca/parks/prd/facilities/outdoor-pools/index.htm

#Done
# figure out how to split multiple swim times into arra