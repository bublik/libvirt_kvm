#!/usr/bin/env ruby
#NOT WORKED EXAMPLE

require './configure.rb'
dom_name = 'qp39frkwkh7ady'

online_domains = @conn.list_domains
puts "Online domains: #{online_domains.inspect}"

puts 'GET get domain info by Name:'
dom = @conn.lookup_domain_by_name(dom_name)

#interface_network_xml = <<EOF
#<interface type='network'>
#   <mac address='52:54:00:2c:5b:55'/>
#   <source network='default'/>
#   <start mode="onboot"/>
#</interface>
#EOF
#
#dom.attach_device(interface_network_xml)

interface_bridge_xml = <<EOF
<interface type='bridge'>
  <mac address='00:16:3e:58:4b:33'/>
  <source bridge='e8ohzwu867g96v'/>
  <target dev='l0liq5ajf63333'/>
  <model type='e1000'/>
</interface>
EOF

dom.attach_device(interface_bridge_xml)
puts dom.xml_desc
dom.detach_device(interface_bridge_xml)
