#!/usr/bin/env ruby

require 'libvirt'
require 'yaml'

require './configure.rb'

puts "HOST : #{@config['hypervisor']['host']}"
puts "USER : #{@config['hypervisor']['user']}"

@hypervisor = @config['hypervisor']
conn = Libvirt::open("qemu+ssh://#{@hypervisor['user']}@#{@hypervisor['host']}/system")

#online_domains = conn.list_domains
#
##conn.lookup_domain_by_name(name)
#puts 'GET get domain info by ID:'
#dom = conn.lookup_domain_by_id(online_domains.first)

dom = conn.lookup_domain_by_name('hw21tb33hlum1a')
puts "Domain name: #{dom.name}"
puts "Domain info: #{dom.info.inspect}"

puts "Active domains: #{conn.list_domains}.inspect"
puts "ACTIVE ? " + dom.active?.inspect

puts "Shutdown"
dom.shutdown

puts "Active domains: #{conn.list_domains}.inspect"
