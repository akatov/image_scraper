require 'thor'
require 'image_scraper'
require 'pry'

module ImageScraper
  class CLI < Thor
    desc "scrape [URL]", "scrapes a URL for images"
    method_option :depth,
                  :aliases => '-d',
                  :type => :numeric,
                  :desc => 'how many links to follow'
    def scrape(url)
      ImageScraper::Scraper.new.scrape url, :depth => options['depth']
      # puts url
      # puts options
    end

    desc "repl", "starts a repl"
    def repl
      binding.pry
    end

    desc "version", "returns the version"
    def version
      puts ImageScraper::VERSION
    end
  end
end
