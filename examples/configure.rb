require 'libvirt'
require 'yaml'

@config = YAML.load_file('./config.yml')

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

@conn = Libvirt::open("qemu+ssh://#{@hypervisor['user']}@#{@hypervisor['host']}/system")