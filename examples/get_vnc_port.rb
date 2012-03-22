#!/usr/bin/env ruby

require './configure.rb'

require 'nokogiri'

dom = @conn.lookup_domain_by_id(@conn.list_domains.first)
puts "DOM: #{dom.name}"

# parse from XML description
doc = Nokogiri::XML(dom.xml_desc)
port = doc.xpath('//domain/devices/graphics').attribute('port').value
puts "VNC port #{port}"

