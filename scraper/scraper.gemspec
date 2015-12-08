# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = "scraper"
  s.version     = '0.0.0'
  s.authors     = ["Erich Welz"]
  s.email       = "erichwelz@gmail.com"
  s.description = "Scraper to grab City of Toronto lane swim data creating a JSON file with geotagged pools"
  s.summary     = "Scraper to grab City of Toronto lane swim data"
  s.homepage    = "https://github.com/erichwelz/TOSwim"
  s.license     = 'MIT'

  s.files         = ["lib/scraper.rb"]
  s.executables << 'scrape'
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency "bundler", "~> 1.3"
  s.add_dependency "geocoder", "~> 1.2"
  s.add_dependency 'json', '~> 1.8', '>= 1.8.3'
  s.add_dependency "nokogiri", "~> 1.6"
  s.add_dependency "pry", "~> 0.10"
end
