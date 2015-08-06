require 'nokogiri'
require 'open-uri'
require 'pry'
require 'json'
require 'geocoder'

Geocoder.configure(:timeout => 10)
# Gather the pools
def gather_pool_urls()
  @pool_urls = []

  # Gather Pool Data
  for i in 0..1
    url = i == 0 ? "sample_files/indoorpools_1.html" : "sample_files/outdoorpools_1.html"
    doc = Nokogiri::HTML(open(url))

    pools = doc.at_css("#pfrBody > div.pfrListing > table > tbody")

    pool_names ||= []
    pool_names += pools.css('a').map { |link| link.children.text }

    pool_links ||= []
    pool_links += pools.css('a').map { |link| link['href'] }

    pool_addresses ||= []
    address_index_incrementer = pools.css('td').length / pools.css('tr').length
    pools.css('td').each_with_index do |node, index|
      # Address is always second column, table width varies for indoor vs. outdoor
      if index == 1 || (index % address_index_incrementer == 1)
        pool_addresses << node.text
      end
    end

    # Geotag pools
    pool_coordinates ||= []
    pool_addresses.first(5).each do |address|
      #coordinates_arr = Geocoder.coordinates("#{address}, Toronto")
      #pool_coordinates << { latitude: coordinates_arr[0], longitude: coordinates_arr[1] }

      pool_coordinates << { latitude: 50.123, longitude: 50.12 }
      puts "Geocoding... #{address}"
    end
  end

  # Convert Pool Data to Hash
  pool_names.first(5).each_with_index do |pool, index|
    current_pool = {}
    current_pool[:name] = pool_names[index]
    current_pool[:url] = pool_links[index]
    current_pool[:address] = pool_addresses[index]
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
  pools_data = []
  if @pool_urls.nil?
    @pool_urls = JSON.parse(File.read('pool_urls.json'), symbolize_names: true)
  end

  @pool_urls.each do |pool|
    puts "Attempting to scrape: " + pool[:name]
    url = "http://www1.toronto.ca" + pool[:url]
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

      @week_times_and_dates ||= []
      @week_times_and_dates << weeks.merge!(week_dates.zip(week_lane_swim_times).to_h)
      end
    end
  end

  # remove days with no swim times
  @week_times_and_dates.each do |pool|
    # empty days return a single special character
    pool.delete_if { |k, v| v.length == 1 }
  end

  # Convert Pool Data to Hash
  @pool_urls.each_with_index do |pool, index|
    current_pool = {}

    #copy existing keys, IE name, url, address, coordinates
    @pool_urls[index].keys.each { |key| current_pool[key] = @pool_urls[index][key] }

    current_pool[:times] = @week_times_and_dates[index]
    pools_data << current_pool
  end

  File.open("pools_data.json","w") do |f|
    f.write(pools_data.to_json)
    puts "Writing pools_data.json complete"
  end
end

#gather_pool_urls()
gather_pool_swim_times()

# Todo
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