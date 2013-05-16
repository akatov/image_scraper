# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'image_scraper/version'

Gem::Specification.new do |gem|
  gem.name          = "image_scraper"
  gem.version       = ImageScraper::VERSION
  gem.authors       = ["Dmitri Akatov"]
  gem.email         = ["akatov@gmail.com"]
  gem.description   = %q{Download images linked froma  URL}
  gem.summary       = %q{Download images linked froma  URL}
  gem.homepage      = "https://github.com/akatov/image_scraper"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'nokogiri'
  gem.add_dependency 'typhoeus'

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-debugger'
  gem.add_development_dependency 'thor'
end
