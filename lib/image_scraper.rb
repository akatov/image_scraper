require "image_scraper/version"

require 'nokogiri'
require 'typhoeus'
require 'uri'
require 'pry'

module ImageScraper
  # Your code goes here...
  class Scraper
    def initialize
      @images = []
      @urls = []
    end

    # @param [String] url
    # @option opts [Num] :depth (0)
    def scrape(url, opts={})
      # puts url
      depth = (opts.fetch :depth, 0) || 0
      image_urls, page_urls = parse url
      # binding.pry
      image_urls.each do |image|
        if @images.member? image
          next
        end
        @images << image
        puts image
        save_image image
      end
      if depth > 0
        depth = depth - 1
        page_urls.each do |p_u|
          if @urls.member? p_u
            next
          end
          @urls << p_u
          scrape p_u, :depth => depth
        end
      end
    end

    # @param [url] page
    # @return [Array<String>, Array<String>] [image_urls, page_urls]
    def parse(url)
      # binding.pry
      uri = URI.parse url
      page = Nokogiri Typhoeus.get(url).body
      links = (page / 'a').map{|l| l.attribute('href')}.compact.map {|a| uri.merge a.value rescue nil}.compact.map(&:to_s)
      images = (page / 'img').map {|n| n.attribute('src')}.compact.map{|a| uri.merge a.value rescue nil}.compact.map(&:to_s)
      [images, links]
    end

    def save_image(url)
      r = Typhoeus.get url
      name = url.sub(/\//, '-')
      File.open("images/#{ name }", 'wb') { |fp| fp.write(r.body) }
    end

  end
end
