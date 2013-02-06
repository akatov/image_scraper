require "image_scraper/version"

require 'nokogiri'
require 'typhoeus'
require 'uri'
require 'pry'

module ImageScraper
  # Your code goes here...
  class Scraper
    def initialize
      @images = Set.new
      @urls = Set.new
    end

    def scrape(url, opts= {})
      do_scrape url, opts
      download_images
    end

    # @param [String] url
    # @option opts [Num] :depth (0)
    def do_scrape(url, opts={})
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
      end
      if depth > 0
        depth = depth - 1
        page_urls.each do |p_u|
          if @urls.member? p_u
            next
          end
          @urls << p_u
          do_scrape p_u, :depth => depth
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

    def download_images
      hydra = Typhoeus::Hydra.new
      requests = @images.map{|url| Typhoeus::Request.new url }
      requests.each do |request|
        name = request.base_url.gsub(/\//, '-')
        request.on_complete do |res|
          File.open("images/#{ name }", 'wb') { |fp| fp.write(res.body) }
        end
        hydra.queue(request)
      end
      hydra.run
    end

  end
end
