require 'nokogiri'
require 'open-uri'
require 'pry'

url = "http://www1.toronto.ca/parks/prd/facilities/complex/2012/"
doc = Nokogiri::HTML(open(url))

weeks = []
for i in 0..1 #eventually poll more weeks, possibly 4 of available 7

  week = doc.at_css("#dropin_Swimming_#{i}").text

  week_dates = doc.at_css("#dropin_Swimming_#{i} tr").children.map(&:text)

  lane_swim_row_index = doc.at_css("#dropin_Swimming_#{i} tbody").css('tr')
                           .find_index { |el| el.text=~ /Lane Swim/ }

  week_lane_swim_times = doc.at_css("#dropin_Swimming_#{i} tbody").css('tr')[lane_swim_row_index].children
     .map do |el|
            nodes = el.children.find_all(&:text?)
              if nodes.length == 1
                nodes = el.children.text
              else
                nodes.map!(&:text)
              end
              nodes
            end

  #remove empty index 0's
  week_dates.shift
  week_lane_swim_times.shift

  weeks.push(week_dates.zip(week_lane_swim_times).to_h)
end

puts weeks
## Todo

#capture pool lists

#Indoor pools list: http://www1.toronto.ca/parks/prd/facilities/outdoor-pools/index.htm
#Outdoor pools list: http://www1.toronto.ca/parks/prd/facilities/outdoor-pools/index.htm

#Done
# figure out how to split multiple swim times into array
# loop for multiple weeks
# build a hash