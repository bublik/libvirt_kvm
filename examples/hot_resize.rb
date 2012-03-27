#!/usr/bin/env ruby
#NOT WORKED EXAMPLE

require './configure.rb'

online_domains = @conn.list_domains
puts "Online domains: #{online_domains.inspect}"

puts 'GET get domain info by ID:'
dom = @conn.lookup_domain_by_id(online_domains.first)

puts "Start manage domain: #{dom.inspect}"

#==== MEMORY
puts "Max Memory: #{ dom.max_memory}"
begin
  puts "Try to Set Max Memory"
  dom.max_memory = dom.max_memory + 100
rescue => e
  puts e
end

begin
  puts "Try to increase Memory"
  dom.memory =
rescue => e
  puts e
end

puts "Max Memory: #{ dom.max_memory}"


#==== CPU
puts "dom.get_vcpus #{dom.get_vcpus}"

puts "max_vcpus: #{dom.max_vcpus}"
begin
  puts "Try to Set Max Memory"
rescue => e
  puts e
end

puts "Max Memory: #{ dom.max_memory}"

@conn.close