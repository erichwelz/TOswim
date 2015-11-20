require "bundler"
Bundler.setup :default

require 'nokogiri'
require 'open-uri'
require 'pry'
require 'json'
require 'geocoder'

Geocoder.configure(:timeout => 10)

def swim_time_finder(week, lane_swim_row_index)
  week.at_css("tbody").css('tr')[lane_swim_row_index].children
  .map do |el|
    nodes = el.children.find_all(&:text?)
    if nodes.length == 1
      nodes = [el.children.text]
    else
      nodes.map!(&:text)
    end
  end
end

def build_pool_schedule_array_from_html(doc)
  weeks = {}

  for i in 0..1 #eventually poll more weeks, possibly 4 of available 7
    week = doc.at_css("#dropin_Swimming_#{i}")
    !week.nil?? week_dates = week.at_css('tr').children.map(&:text) : next

    !week_dates.nil?? lane_swim_row_index = week.at_css("tbody").css('tr').find_index { |el| el.text=~ /Lane Swim/ } : next

    if !lane_swim_row_index.nil?
      week_lane_swim_times = swim_time_finder(week, lane_swim_row_index)
      weeks.merge!(week_dates.zip(week_lane_swim_times).to_h)
    end
  end

  # remove days with no swim times
  weeks.delete_if { |day| day.length <= 1 }
end

# Gather the pools
def gather_pool_urls()
  @pool_urls, @pool_names, @pool_addresses, @pool_links = [],[],[],[]

  # Gather Pool Data
  urls = ["http://www1.toronto.ca/parks/prd/facilities/indoor-pools/index.htm",
          "http://www1.toronto.ca/parks/prd/facilities/indoor-pools/2-indoor_pool.htm",
          "http://www1.toronto.ca/parks/prd/facilities/outdoor-pools/index.htm",
          "http://www1.toronto.ca/parks/prd/facilities/outdoor-pools/2-outdoor_pool.htm"]

  urls.each do |url|
    doc = Nokogiri::HTML(open(url))
    pools = doc.at_css("#pfrBody > div.pfrListing > table > tbody")
    @pool_names += pools.css('a').map { |link| link.children.text }
    @pool_links += pools.css('a').map { |link| link['href'] }

    address_index_incrementer = pools.css('td').length / pools.css('tr').length
    pools.css('td').each_with_index do |node, index|
      # Address is always second column, table width varies for indoor vs. outdoor
      if index == 1 || (index % address_index_incrementer == 1)
        @pool_addresses << node.text
      end
    end
  end

  # Geotag pools
  pool_coordinates ||= []
  @pool_addresses.each do |address|
    coordinates_arr = Geocoder.coordinates("#{address}, Toronto")
    pool_coordinates << { latitude: coordinates_arr[0], longitude: coordinates_arr[1] }

    # pool_coordinates << { latitude: 50.123, longitude: 50.12 }
    puts "Geocoding... #{address}"

    # To avoid triggering google API limit of 10 queries per second
    sleep(0.15)
  end

  # Convert Pool Data to Hash
  @pool_names.each_with_index do |pool, index|
    current_pool = {}
    current_pool[:name] = @pool_names[index]
    current_pool[:url] = @pool_links[index]
    current_pool[:address] = @pool_addresses[index]
    current_pool[:coordinates] = pool_coordinates[index]
    @pool_urls << current_pool
  end

  # Write Hash
  File.open("pool_urls.json","w") do |f|
    f.write(@pool_urls.to_json)
  end
end

#####Parse Weekly Leisure Swim Data#####
def gather_pool_swim_times
  if @pool_urls.nil?
    @pool_urls = JSON.parse(File.read('pool_urls_subset.json'), symbolize_names: true)
  end

  @pool_urls.each do |pool|
    puts "Attempting to scrape: " + pool[:name]
    url = "http://www1.toronto.ca" + pool[:url]
    doc = Nokogiri::HTML(open(url))
    pool[:times] = build_pool_schedule_array_from_html(doc)
  end

  File.open("pools_data.json","w") do |f|
    f.write(@pool_urls.to_json)
    puts "Writing pools_data.json complete"
  end
end

# gather_pool_urls()
gather_pool_swim_times()


# Todo
# add a test suite, break geotagging into separate method
# break rejecting days into separate method?
# remind self how to log name of vars while blown up (smaller method with info passed in probably!)
#start displaying, filtering?
#maybe transform date save

#Indoor pools list: http://www1.toronto.ca/parks/prd/facilities/outdoor-pools/index.htm
#Outdoor pools list: http://www1.toronto.ca/parks/prd/facilities/outdoor-pools/index.htm

#Bugs

#Done
#figure out how to split multiple swim times into array
#loop for multiple weeks
#build hashes
#capture indoor pool lists
#determine output, save as json object or YAML?
# Pool geocode data - http://www.rubygeocoder.com/
# Symbolize keys for JSON retrieval as JSON doesn't natively support keys, rather uses strings
# latitude / longitude, display proper
