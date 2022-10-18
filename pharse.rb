require 'rails'
require 'open-uri'
require 'nokogiri'
require 'action_view'

(2357..7011).each do |id|
  file = File.open("pages/#{id}.html")
  file_data = file.read
  doc = Nokogiri::HTML(file_data)
  title = doc.xpath('//table/tr[3]/td')[0].to_s
  # pub_date = doc.xpath('//table/tr[1]/td')[0].to_s
  # du_date = doc.xpath('//table/tr[2]/td')[0].to_s
  body = doc.xpath('//table/tr[4]/td')[0].to_s

  title = ActionView::Base.full_sanitizer.sanitize(title).squish
  body = ActionView::Base.full_sanitizer.sanitize(body).squish.delete(' ')
  result = "#{title}\n#{body}"
  File.open("./txt/#{id}", 'w+') { |file| file.write(result) }
end
