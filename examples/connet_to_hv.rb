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

# retrieve basic information about the hypervisor.  See the libvirt
# documentation for more information about what each of these fields mean.
nodeinfo = conn.node_get_info
puts "Hypervisor Nodeinfo:"
puts " Model:         #{nodeinfo.model}"
puts " Memory:        #{nodeinfo.memory}"
puts " CPUs:          #{nodeinfo.cpus}"
puts " MHz:           #{nodeinfo.mhz}"
puts " (NUMA) Nodes:  #{nodeinfo.nodes}"
puts " Sockets:       #{nodeinfo.sockets}"
puts " Cores:         #{nodeinfo.cores}"
puts " Threads:       #{nodeinfo.threads}"

# print the amount of free memory in every NUMA node on the hypervisor
begin
  cellsmem = conn.node_cells_free_memory
  puts "Hypervisor NUMA node free memory:"
  cellsmem.each_with_index do |cell,index|
    puts " Node #{index}: #{cell}"
  end
rescue
  # this call may not be supported; if so, just ignore
end

# print the type of the connection.  This will be "QEMU" for qemu, "XEN" for
# xen, etc.
puts "Hypervisor Type: #{conn.type}"
# print the hypervisor version
puts "Hypervisor Version: #{conn.version}"
# print the libvirt version on the hypervisor
puts "Hypervisor Libvirt version: #{conn.libversion}"
# print the hypervisor hostname (deprecated)
puts "Hypervisor Hostname: #{conn.hostname}"
puts "Hypervisor Max Vcpus: #{conn.max_vcpus}"
puts "Domains (VMs - online): #{conn.num_of_domains}"
puts "Retrieve a list of inactive domain names on this connection:  #{conn.list_defined_domains.inspect}"

online_domains = conn.list_domains
puts "Online Domains: #{online_domains.inspect}"
puts 'GET get domain info by ID:'
puts conn.lookup_domain_by_id(online_domains.first).inspect


# print the URI in use on this connection.  Note that this may be different
# from the one passed into Libvirt::open, since libvirt may decide to
# canonicalize the URI
puts "Hypervisor URI: #{conn.uri}"
# print the amount of free memory on the hypervisor
begin
  puts "Hypervisor Free Memory: #{conn.node_free_memory}"
rescue
  # this call may not be supported; if so, just ignore
end

# print the security model in use on the hypervisor
secmodel = conn.node_get_security_model
puts "Hypervisor Security Model:"
puts " Model: #{secmodel.model}"
puts " DOI:   #{secmodel.doi}"

# print whether the connection to the hypervisor is encrypted
puts "Hypervisor connection encrypted?: #{conn.encrypted?}"
# print whether the connection to the hypervisor is secure
puts "Hypervisor connection secure?: #{conn.secure?}"
# print the capabilities XML for the hypervisor.  A detailed explanation of
# the XML format can be found in the libvirt documentation.
#puts "Hypervisor capabilities XML:"
#puts conn.capabilities

#
# # close the connection
 conn.close
#
# # after close, the closed? should return true
 puts "After close, connection closed?: #{conn.closed?}"
