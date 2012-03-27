#!/usr/bin/env ruby

require './configure.rb'

#Find domain by name
dom_name = 'w7jtb3e0baine9'
dom = @conn.lookup_domain_by_name(dom_name)

#create destination vibvirt connection

@conn2 = Libvirt::open("qemu+ssh://root@109.123.91.51/system")

# +virDomainMigrate+[http://www.libvirt.org/html/libvirt-libvirt.html#virDomainMigrate]
#  Before migration need activate  node LV disks on target hypervisor
# lvchange -a y /dev/onapp-v1vgz2q0yevwzt/dkqmmd9yzf87gz
# lvchange -a y /dev/onapp-v1vgz2q0yevwzt/rgfm60xq00rz0p
dom.migrate(@conn2)