require 'thor'
require 'pry'

require 'image_scraper'

module ImageScraper
  class CLI < Thor
    desc "scrape [URL]", "scrapes a URL for images"
    def scrape(url)
      puts url
    end
  end
end
