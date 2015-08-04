require 'nokogiri'
require 'open-uri'
require 'pry'

#######Find Indoor Pools#######
all_pool_info = {}

for i in 0..1
  i == 0 ? url = "http://www1.toronto.ca/parks/prd/facilities/indoor-pools/index.htm" : url = "http://www1.toronto.ca/parks/prd/facilities/indoor-pools/2-indoor_pool.htm"
  doc = Nokogiri::HTML(open(url))

  pools = doc.at_css("#pfrBody > div.pfrListing > table > tbody")
  pool_links = pools.css('a').map { |link| link['href'] }
  pool_names = pools.css('a').map { |link| link.children.text }

  all_pool_info.merge!(pool_names.zip(pool_links).to_h)
end
# puts all_pool_info

#####Parse Weekly Leisure Swim Data#####

url = "http://www1.toronto.ca" + all_pool_info['Regent Park Aquatic Centre']
doc = Nokogiri::HTML(open(url))

weeks = {}
for i in 0..1 #eventually poll more weeks, possibly 4 of available 7

  week = doc.at_css("#dropin_Swimming_#{i}")

  week_dates = week.at_css('tr').children.map(&:text)

  lane_swim_row_index = week.at_css("tbody").css('tr')
                           .find_index { |el| el.text=~ /Lane Swim/ }

  week_lane_swim_times = week.at_css("tbody").css('tr')[lane_swim_row_index].children
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

  weeks.merge!(week_dates.zip(week_lane_swim_times).to_h)
end

puts weeks

# Todo
#capture indoor pool lists

#Indoor pools list: http://www1.toronto.ca/parks/prd/facilities/outdoor-pools/index.htm
#Outdoor pools list: http://www1.toronto.ca/parks/prd/facilities/outdoor-pools/index.htm

#Done
#figure out how to split multiple swim times into array
#loop for multiple weeks
#build hashes