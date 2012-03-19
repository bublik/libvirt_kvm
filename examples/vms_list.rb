#!/usr/bin/env ruby

require './configure.rb'

# list of inactive domain names on this connection.
list_defined_domains = conn.list_defined_domains

puts "Offline domains: #{list_defined_domains.inspect}"
list_defined_domains.each do |name|
  dom = conn.lookup_domain_by_name(name)
  puts dom.name
end

puts '=============='
# list active VMs
online_domains = conn.list_domains

puts "Online domains: #{online_domains.inspect}"
online_domains.each do |dom_id|
  _dom = conn.lookup_domain_by_id(dom_id.to_i)
  puts _dom.name
end
