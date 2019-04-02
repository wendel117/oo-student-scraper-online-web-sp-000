require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css('.student-card a').each do |student|
      students << { name: student.css('.student-name').text, location: student.css('.student-location').text, profile_url: student.attr('href') }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    doc = Nokogiri::HTML(open(profile_url))
    social_links = doc.css('.social-icon-container a').map { |x| x.attr('href') }
    social_links.each do |i|
      if i.include?('twitter')
        student[:twitter] = i
      elsif i.include?('linkedin')
        student[:linkedin] = i
      elsif i.include?('github')
        student[:github] = i
      else
        student[:blog] = i
      end
    end
    student[:profile_quote] = doc.css('.profile-quote').text if doc.css('.profile-quote').text
    student[:bio] = doc.css('.bio-content div p').text if doc.css('.bio-content div p').text
    student
  end
end
