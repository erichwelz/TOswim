require 'nokogiri'
require 'open-uri'
require 'pry'
require 'json'

#######Find Indoor Pools#######
def gather_pool_urls()
  @pool_urls = {}

  for i in 0..1
    url = i == 0 ? "http://www1.toronto.ca/parks/prd/facilities/indoor-pools/index.htm" : "http://www1.toronto.ca/parks/prd/facilities/indoor-pools/2-indoor_pool.htm"
    doc = Nokogiri::HTML(open(url))

    pools = doc.at_css("#pfrBody > div.pfrListing > table > tbody")
    pool_links = pools.css('a').map { |link| link['href'] }
    pool_names = pools.css('a').map { |link| link.children.text }

    @pool_urls.merge!(pool_names.zip(pool_links).to_h)
  end

  File.open("pool_urls.json","w") do |f|
    f.write(@pool_urls.to_json)
  end
end

#####Parse Weekly Leisure Swim Data#####
def gather_pool_swim_times
  pools_data = {}
  if @pool_urls.nil?
    @pool_urls = JSON.parse(File.read('pool_urls.json'))
  end

  @pool_urls.each do |pool|
    puts "Attempting to scrape: " + pool[0]
    url = "http://www1.toronto.ca" + pool[1]
    doc = Nokogiri::HTML(open(url))

    weeks = {}

    for i in 0..1 #eventually poll more weeks, possibly 4 of available 7

      week = doc.at_css("#dropin_Swimming_#{i}")
      !week.nil?? week_dates = week.at_css('tr').children.map(&:text) : next

      !week_dates.nil?? lane_swim_row_index = week.at_css("tbody").css('tr')
                               .find_index { |el| el.text=~ /Lane Swim/ } : next

      if !lane_swim_row_index.nil?
        week_lane_swim_times = week.at_css("tbody").css('tr')[lane_swim_row_index].children
           .map do |el|
                  nodes = el.children.find_all(&:text?)
                    if nodes.length == 1
                      nodes = el.children.text
                    else
                      nodes.map!(&:text)
                    end
                  end
      #remove empty index 0's
      week_dates.shift
      week_lane_swim_times.shift
      pools_data[pool[0]] = weeks.merge!(week_dates.zip(week_lane_swim_times).to_h)
      end
    end
  end

  File.open("pools_data.json","w") do |f|
    f.write(pools_data.to_json)
  end
end

#gather_pool_urls()
gather_pool_swim_times()

# Todo
# remind self how to log name of vars while blown up (smaller method with info passed in probably!)
# struct instead of array for pool data?
# Pool geocode data
#start displaying, filtering?
#maybe transform date save

#Indoor pools list: http://www1.toronto.ca/parks/prd/facilities/outdoor-pools/index.htm
#Outdoor pools list: http://www1.toronto.ca/parks/prd/facilities/outdoor-pools/index.htm

#Done
#figure out how to split multiple swim times into array
#loop for multiple weeks
#build hashes
#capture indoor pool lists
#determine output, save as json object or YAML?