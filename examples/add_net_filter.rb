#!/usr/bin/env ruby

require './configure.rb'

nwfilter_xml = <<EOF
<filter name='test-define-filter' chain='ipv4'>
  <uuid>bd339530-134c-6d07-441a-17fb90dad807</uuid>
  <rule action='accept' direction='out' priority='100'>
    <ip srcipaddr='0.0.0.0' dstipaddr='255.255.255.255' protocol='tcp' srcportstart='63000' dstportstart='62000'/>
  </rule>
  <rule action='accept' direction='in' priority='100'>
    <ip protocol='tcp' srcportstart='63000' dstportstart='62000'/>
  </rule>
</filter>
EOF

puts '== Print out how many filters are currently defined'
puts "Number of nwfilters: #{@conn.num_of_nwfilters}"

puts '== List existing network filters'
@conn.list_nwfilters.each do |f|
  puts f
end

# define our new filter
nwf = @conn.define_nwfilter_xml(nwfilter_xml)

# now there should be one more filter than before
puts "Number of nwfilters: #{@conn.num_of_nwfilters}"

# print out some information about our filter
puts "NWFilter:"
puts " Name: #{nwf.name}"
puts " UUID: #{nwf.uuid}"

# remove the filter
nwf.undefine

@conn.close