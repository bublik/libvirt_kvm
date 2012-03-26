#!/usr/bin/env ruby

require './configure.rb'
puts "After add VG libvirt will create XML config file  /etc/libvirt/storage/onapp-v1vgz2q0yevwzt.xml"
# this program demonstrates the use of the libvirt storage APIs.  In particular
# it demonstrates directory pool creation, volume creation, and teardown.
# libvirt supports many other kinds of storage pools, including iSCSI, NFS,
# etc.  See http://libvirt.org/formatstorage.html for more details

# See http://www.libvirt.org/storage.html#StorageBackendLogical

#[root]# vgdisplay
#--- Volume group ---
#VG Name               onapp-v1vgz2q0yevwzt
#System ID
#Format                lvm2
#Metadata Areas        1
#Metadata Sequence No  5
#VG Access             read/write
#VG Status             resizable
#MAX LV                0
#Cur LV                4
#Open LV               4
#Max PV                0
#Cur PV                1
#Act PV                1
#VG Size               6,37 TiB
#PE Size               4,00 MiB
#Total PE              1668899
#Alloc PE / Size       4096 / 16,00 GiB
#Free  PE / Size       1664803 / 6,35 TiB
#VG UUID               S8ALpl-2gYP-Rr8D-uei2-6xLs-Shul-th1QOt

puts @conn.discover_storage_pool_sources('logical')
#<sources>
#  <source>
#    <device path='/dev/sda2'/>
#    <name>vg_dev3hv1</name>
#    <format type='lvm2'/>
#  </source>
#  <source>
#    <device path='/dev/sdb'/>
#    <name>onapp-v1vgz2q0yevwzt</name>
#    <format type='lvm2'/>
#  </source>
#</sources>

# a directory storage pool.  This will be a pool with the name
# 'ruby-libvirt-tester' with the pool itself in /tmp/ruby-libvirt-tester
storage_pool_xml = <<EOF
<pool type="logical">
  <device>/dev/sdb</device>
  <name>onapp-v1vgz2q0yevwzt</name>
  <format type='lvm2'/>
  <target>
    <path>/dev/onapp-v1vgz2q0yevwzt</path>
  </target>
</pool>
EOF

# a storage volume.  This will have name test.img, with capacity of 1GB
# and allocation of 0.  The difference between allocation and capacity is the
# maximum allowed for a volume (capacity) versus how much is currently
# allocated (allocation).  If allocation < capacity, then this is a
# thinly-provisioned volume (think of a sparse file)
storage_vol_xml = <<EOF
<volume>
  <name>testhv2.img</name>
  <allocation>0</allocation>
  <capacity unit="G">1</capacity>
  <format type='linux-lvm'/>
  <target>
    <path>/dev/onapp-v1vgz2q0yevwzt/testhv2.img</path>
  </target>
</volume>
EOF


# print out how many storage pools are currently active
puts "Number of storage pools: #{@conn.num_of_storage_pools}"
puts pools_list = @conn.list_storage_pools
# => ["onapp-v1vgz2q0yevwzt"]

unless pools_list.include?('onapp-v1vgz2q0yevwzt')
# create our new storage pool if it is does not defined on libvirt
  pool = @conn.define_storage_pool_xml(storage_pool_xml)

# build the storage pool.  The operation that this performs is pool-specific;
# in the case of a directory pool, it does the equivalent of mkdir to create
# the directory
# SKIP
#/sbin/vgcreate onapp-v1vgz2q0yevwzt
#pool.build

# start up the pool
  pool.create
else
  pool = @conn.lookup_storage_pool_by_name('onapp-v1vgz2q0yevwzt')
end

puts pool.xml_desc

# print out how many active storage pools are now there; this should be one
# more than before
puts "Number of storage pools: #{@conn.num_of_storage_pools}"

# print out some information about the pool.  Note that allocation can be
# much less than capacity; see the discussion for the storage volume XML for
# more details
puts "Storage Pool:"
puts " Name: #{pool.name}"
puts " UUID: #{pool.uuid}"
puts " Autostart?: #{pool.autostart?}"
poolinfo = pool.info
puts " Info:"
puts "  State: #{poolinfo.state}"
puts "  Capacity: #{poolinfo.capacity / 1024}kb"
puts "  Allocation: #{poolinfo.allocation / 1024}kb"
puts "  Available: #{poolinfo.available / 1024}kb"
puts " Number of volumes: #{pool.num_of_volumes}"

# create a new volume in the storage pool.  What happens on volume creation
# is pool-type specific.  In the case of a directory pool, this creates the
# file

# print out how many volumes are in our pool; there should now be 1
puts " Number of volumes: #{pool.num_of_volumes}"
puts pool.list_volumes
# ["t57qjlplxpvyvs", "hckzsku2n9mq2m", "njcn6m028t81qu", "gihjxn3efnkyuv"]

unless pool.list_volumes.include?('test.img')
  puts "Create LV"
  vol = pool.create_volume_xml(storage_vol_xml)
else
  vol = pool.lookup_volume_by_name('test.img')
end

# refresh the pool, which rescans the pool for any changes to the pool including
# new or deleted volumes.  While this isn't strictly necessary
# (create_volume_xml already does this), it is a good habit to get into when
# making changes to a pool
pool.refresh

puts "Find first LV"
temp_vol = pool.lookup_volume_by_name(pool.list_volumes.first)
puts temp_vol.name
puts temp_vol.key
puts "XML desc of volume"
puts temp_vol.xml_desc

puts 'New created LV'
# print out some information about the volume.  Again, see the discussion
# for the storage volume XML to understand the differences between allocation
# and capacity
puts "Storage Volume:"
puts " Name: #{vol.name}"
puts " Key: #{vol.key}"
puts " Path: #{vol.path}"
puts " Pool: #{vol.pool.name}"
volinfo = vol.info
puts " Info:"
puts "  Type: #{volinfo.type}"
puts "  Capacity: #{volinfo.capacity / 1024/1024}Mb"
puts "  Allocation: #{volinfo.allocation / 1024/1024}Mb"

exit
#CLEAN ALL PRIVATE DATA
# wipe the data from this storage volume. This is a destructive operation.
puts "Start WIPE the data"
puts Time.now
vol.wipe
puts Time.now

# delete the volume.  What happens here is pool-type specific; for a directory
# pool, the file is erased
puts "Delete volume"
vol.delete
puts " Number of volumes: #{pool.num_of_volumes}"

# destroy the pool
# WARNING
# FULL LVG DESTROY
# virStoragePoolDestroy failed: internal error Child process (/sbin/vgchange -an onapp-v1vgz2q0yevwzt) status unexpected: exit status 5
#pool.destroy

# undefine the pool
# Active Pool can't be undefined
pool.undefine unless pool.active?

@conn.close