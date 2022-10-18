require 'rails'
require 'open-uri'
require 'nokogiri'

url = "https://www.e-quit.org/News/NewsDetails.aspx?&NewId="
(2357..7011).each do |id|
  sleep 1
  doc = Nokogiri::HTML(URI.open("#{url}#{id}"))
  txt = doc.xpath('//*[@id="ZOOM"]/div/div/table')[0]
  File.open("./pages/#{id}.html", 'w+') { |file| file.write(txt) }
end
