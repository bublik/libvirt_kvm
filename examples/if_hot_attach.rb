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

=begin
Supported 
 libvirt 0.9.11

http://www.redhat.com/archives/libvir-list/2012-February/msg00222.html

This patch allows libvirt to add interfaces to already
existing Open vSwitch bridges. The following syntax in
domain XML file must be used:

    <interface type='bridge'>
      <mac address='52:54:00:d0:3f:f2'/>
      <source bridge='ovsbr'/>
      <virtualport type='openvswitch'>
        <parameters interfaceid='921a80cd-e6de-5a2e-db9c-ab27f15a6e1d'/>
      </virtualport>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
    </interface>

or if libvirt should auto-generate the interfaceid us following syntax:

    <interface type='bridge'>
      <mac address='52:54:00:d0:3f:f2'/>
      <source bridge='ovsbr'/>
      <virtualport type='openvswitch'>
      </virtualport>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
    </interface>

To create Open vSwitch bridge us following command:

    ovs-vsctl add-br ovsbr
=end
