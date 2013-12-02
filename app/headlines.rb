require 'nokogiri'
require 'open-uri'

module Headlines

	PAGE_URL = "http://www.theonion.com"

	def get_onion_headline
		page = Nokogiri::HTML(open(PAGE_URL))
		page.css(".primary .article .title").text
	end
end