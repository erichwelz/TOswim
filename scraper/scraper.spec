Gem::Specification.new do |s|
  s.name        = "scraper"
  s.version     = '0.0.0'
  s.authors     = ["Erich Welz"]
  s.email       = erichwelz@gmail.com"
  s.homepage    = "https://github.com/erichwelz/TOSwim"
  s.summary     = "Scraper to grab City of Toronto lane swim data"
  s.license     = 'MIT'
  s.files         = `git ls-files`.split("\n")

  s.add_development_dependency "bundler", "~> 1.0"
  s.add_development_dependency "geocoder", ">= 1.2"
  s.add_development_dependency "json", "~> 1.8"
  s.add_development_dependency "nokogiri", "~> 1.6.6"
  s.add_development_dependency "pry", "~> 0.10"
end

