# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "scraper"
  s.version     = '0.0.0'
  s.executables << 'scrape'
  s.authors     = ["Erich Welz"]
  s.email       = "erichwelz@gmail.com"
  s.homepage    = "https://github.com/erichwelz/TOSwim"
  s.summary     = "Scraper to grab City of Toronto lane swim data"
  s.description = "Scraper to grab City of Toronto lane swim data"
  s.license     = 'MIT'
  s.files         = ["lib/scraper.rb"]

  s.add_dependency "bundler", "~> 1.0"
  s.add_dependency "geocoder", "~> 1.2"
  s.add_dependency "json", "~> 1.8"
  s.add_dependency "nokogiri", "~> 1.6"
  s.add_dependency "pry", "~> 0.10"
end
