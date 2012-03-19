#!/usr/bin/env ruby

require 'libvirt'
require 'yaml'

require './configure.rb'

puts "HOST : #{@config['hypervisor']['host']}"
puts "USER : #{@config['hypervisor']['user']}"

@hypervisor = @config['hypervisor']

# the open method is a module method.  It can take 0 or 1 parameters; with 0
# # parameters, libvirt attempts to auto-connect to a hypervisor for you (not
# # recommended).  If a parameter is passed, it must be a valid libvirt URI
# conn = Libvirt::open("qemu:///system")

#conn = Libvirt::open("qemu+ssh://#{@config['user']}@#{@config['host']}/system")
ver = Libvirt::version()
puts "Libvirt version: #{ver[0]}"
puts "Hypervisor Type version: #{ver[1]}"

conn = Libvirt::open("qemu+ssh://#{@hypervisor['user']}@#{@hypervisor['host']}/system")

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
