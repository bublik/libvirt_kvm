#!/usr/bin/env ruby

require 'libvirt'
require 'yaml'

require './configure.rb'

puts "HOST : #{@config['hypervisor']['host']}"
puts "USER : #{@config['hypervisor']['user']}"

@hypervisor = @config['hypervisor']
UUID = "93a5c045-6457-2c09-e5ff-927cdf34e17b"
DOM_NAME = 'hw21tb33hlum1a'
new_dom_xml = '<?xml version="1.0" encoding="UTF-8"?>
    <domain type="kvm">
<name>hw21tb33hlum1a</name>
  <description>QAVP</description>
<memory>131072</memory>
  <currentMemory>131072</currentMemory>
<vcpu>1</vcpu>
  <features>
    <pae/>
<acpi/>
<apic/>
</features>
  <os>
    <type machine="pc" arch="x86_64">hvm</type>
<boot dev="fd"/>
</os>
  <devices>
    <emulator>/usr/libexec/qemu-kvm</emulator>
    <disk type="file" device="floppy">
      <source file="/onapp/tools/grub.img"/>
      <target dev="fda"/>
      <readonly/>
    </disk>
    <disk type="block" device="disk">
      <source dev="/dev/onapp-pboo5tdyyvbm71/l8v6gan17uxrnj"/>
      <target dev="hda" bus="ide"/>
    </disk>
    <disk type="block" device="disk">
      <source dev="/dev/onapp-pboo5tdyyvbm71/sa7e51a9g01e1y"/>
      <target dev="hdb" bus="ide"/>
    </disk>
    <interface type="bridge">
      <source bridge="xpbaeye5b6449y"/>
      <mac address="00:16:3e:35:c9:c7"/>
      <target dev="ke86ur4blvh2h3"/>
      <filterref filter="no-spoofing">
        <parameter value="109.123.125.178" name="IP"/>
      </filterref>
      <model type="e1000"/>
    </interface>
    <graphics type="vnc" listen="0.0.0.0" passwd="aw27lxfv478h"/>
    <input type="tablet" bus="usb"/>
  </devices>
</domain>
'
########---------------------------------------------------------------
conn = Libvirt::open("qemu+ssh://#{@hypervisor['user']}@#{@hypervisor['host']}/system")

## list of inactive domain names on this connection.
#list_defined_domains = conn.list_defined_domains
#
#if list_defined_domains.include?(DOM_NAME)

# create the domain from the XML above.  This actually defines the domain
# and starts it at the same time.  Domains created this way are transient;
# once they are stopped, libvirt forgets about them.
puts "Creating transient domain ruby-libvirt-tester"
begin
  dom = conn.create_domain_xml(new_dom_xml)
rescue
  dom.undefine
end

# stop the domain.  Because this is a transient domain, libvirt will no longer
# remember this domain after this call
puts "Destroying transient domain ruby-libvirt-tester"
dom.destroy
# define the domain from the XML above.  Note that defining a domain just
# makes libvirt aware of the domain as a persistent entity; it does not start
# or otherwise change the domain
puts "Defining permanent domain ruby-libvirt-tester"
dom = conn.define_domain_xml(new_dom_xml)

# start the domain
puts "Starting permanent domain ruby-libvirt-tester"
dom.create

sleep 2

puts "Domain name: #{dom.name}"
puts "Domain info: #{dom.info.inspect}"
puts "ACTIVE ? " + dom.active?.inspect
puts "Active domains: #{conn.list_domains}.inspect"


begin
  # undefine the domain.  Oops!  This raises an exception since it is not legal
  # to undefine a running domain
  puts "Trying to undefine running domain ruby-libvirt-tester"
  dom.undefine
rescue => e
  puts e
end

# stop the domain.  Because this is a permanent domain, libvirt will stop the
# execution of the domain, but will remember the domain for next time
puts "Destroying running domain ruby-libvirt-tester"
dom.destroy

puts "Domain info after destroy: #{dom.info.inspect}"

# undefine the domain; the dom object is no longer valid after this operation
puts "Undefining permanent domain ruby-libvirt-tester"
dom.undefine

conn.close


