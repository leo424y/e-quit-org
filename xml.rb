require 'rails'
require "rexml/document"
require 'open-uri'
require 'nokogiri'
require 'action_view'

def tags tag
  %{<ns0:category scheme="http://www.blogger.com/atom/ns#" term="#{tag}" />}
end


head = %{<?xml version='1.0' encoding='UTF-8'?>
<ns0:feed xmlns:ns0="http://www.w3.org/2005/Atom">
  <ns0:title type="html">Any Theme</ns0:title>
  <ns0:generator>Blogger</ns0:generator>
  <ns0:updated>2022-10-18T16:35:50Z</ns0:updated>

}
main_body = ''
(2449..2450).each do |id|
  file = File.open("pages/#{id}.html")
  file_data = file.read
  doc = Nokogiri::HTML(file_data)
  title = doc.xpath('//table/tr[3]/td')[0].to_s
  pub_date = ActionView::Base.full_sanitizer.sanitize(doc.xpath('//table/tr[1]/td')[0].to_s).squish

  body = CGI.escapeHTML doc.xpath('//table/tr[4]/td')[0].to_s

  tags_file = File.open("keywords/#{id}").read
  tags = tags_file.split(',')

  main_body += %{
    <ns0:entry>
    #{tags.map {|t| tags(t)}.join("\n")}
    <ns0:category scheme="http://schemas.google.com/g/2005#kind" term="http://schemas.google.com/blogger/2008/kind#post" />
    <ns0:id>post-10</ns0:id>
    <ns0:author>
      <ns0:name>華文戒菸網</ns0:name>
    </ns0:author>
    <ns0:content type="html">#{body}</ns0:content>
    <ns0:published>#{pub_date}</ns0:published>
    <ns0:title type="html">#{title}</ns0:title>
    </ns0:entry>
  }
end

tail = %{
</ns0:feed>
}

source="#{head}#{main_body}#{tail}"

doc = REXML::Document.new(source)
formatter = REXML::Formatters::Pretty.new

# Compact uses as little whitespace as possible
formatter.compact = true
formatter.write(doc, $stdout)
File.open("./xml/xml.xml", 'w+') { |file| file.write(doc) }
