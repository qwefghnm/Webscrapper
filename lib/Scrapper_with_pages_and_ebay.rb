
require 'rubygems'
require 'mechanize'
require 'open-uri'
class Object_oriented_scrape
  def initialize
    @agent = Mechanize.new
    puts "Which site would like, Amazon or Ebay"
    @site = gets.chomp.downcase
    if @site == "amazon"
      amazon_Search
    else
      ebay_search
    end
  end
  def amazon_Search
    page = @agent.get("http://Amazon.com")
    search_form = page.form_with(name: "site-search")
    search_field = search_form.field_with(type: "text")
    puts "What product would you like to scrape"
    seach_value = gets.chomp
    search_field.value = "#{seach_value}"
    page = search_form.submit
    puts "How many pages would you like to scrape"
    page_count = gets.chomp.to_i
      while page_count !=0
        doc = Nokogiri::HTML(open("#{page.uri}"))
        doc.css("div [class = 'rslt prod celwidget']").each do |el|
          puts name = el.css("span [class = 'lrg bold']").text.strip
          puts price = el.css("span [class = 'bld lrg red']").text.strip
          end
          next_page = page.at("a[title='Next Page']")
          page = @agent.click(next_page)
          page_count = page_count-1
      end
  end
  def ebay_search
    page = @agent.get("http://ebay.com")
    search_form = page.form_with(action: "http://www.ebay.com/sch/i.html")
    search_field = search_form.field_with(type: "text")
    puts "What product would you like to scrape"
    seach_value = gets.chomp
    search_field.value = "#{seach_value}"
    page = search_form.submit
    puts "How many pages would you like to scrape"
    page_count = gets.chomp.to_i
      while page_count !=0
        doc = Nokogiri::HTML(open("#{page.uri}"))
        doc.css("table [class = 'li rsittlref ']").each do |el|
          puts name = el.css("a [class= 'vip ']").text.strip.gsub("Newly Listed","")
          puts price = el.css("span [style='color:#']").text.strip
          end
          next_page = page.at("a[title = 'Next page of results']")
          page = @agent.click(next_page)
          page_count = page_count-1
      end
  end
end
Start = Object_oriented_scrape.new()


