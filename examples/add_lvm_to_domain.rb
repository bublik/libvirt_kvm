#!/usr/bin/env ruby

require './configure.rb'

#Install PCI Hotplug drivers in the guest (Linux)
#
#I loaded the following modules to get pci hotplug working:
#
#                                                      acpiphp
#pci_hotplug
#You can either add these to your distro's module list to load on boot, or run a command like this.
#
#for m in acpiphp pci_hotplug; do sudo modprobe ${m}; done

begin
  puts "READ: http://www.linux-kvm.org/page/Virtio"
  puts "READ hot plug devices http://www.linux-kvm.org/page/Hotadd_pci_devices"
  domain_name = 'ws5x2wcb4p3pnz'

  # Add test img
#lvdisplay /dev/onapp-v1vgz2q0yevwzt/test.img
#--- Logical volume ---
#LV Name                /dev/onapp-v1vgz2q0yevwzt/test.img
#VG Name                onapp-v1vgz2q0yevwzt
#LV UUID                pd5LX9-hnuf-n3go-GvDW-U5p2-ltsm-ybjqbY
#LV Write Access        read/write
#LV Status              available
## open                 0
#LV Size                1,00 GiB
#Current LE             256
#Segments               1
#Allocation             inherit
#Read ahead sectors     auto
#- currently set to     256
#Block device           253:8

  begin
    dom = @conn.lookup_domain_by_name(domain_name)
  rescue
    puts 'There is not found avtive domains'
  end

  #<disk type='block' device='disk'>
  #  <driver name='qemu' type='raw'/>
  #  <source dev='/dev/onapp-v1vgz2q0yevwzt/gihjxn3efnkyuv'/>
  #  <target dev='hdb' bus='ide'/>
  #  <alias name='ide0-0-1'/>
  # <address type='drive' controller='0' bus='0' unit='1'/>
  #</disk>

  # Hot attach can be scsi or virtio
  #<target dev='sdb' bus='scsi'/>

  # <target dev='hdc' bus='virtio'/>
  # /dev/vd[a-z][1-9]
test_lv ="<disk type='block' device='disk'>
  <driver name='qemu' type='raw'/>
  <source dev='/dev/onapp-v1vgz2q0yevwzt/test.img'/>
  <target dev='hdc' bus='virtio'/>
  <alias name='ide0-0-2'/>
<address type='drive' controller='0' bus='0' unit='1'/>
</disk>"
  dom.attach_device(test_lv)

  puts dom.xml_desc

end

@conn.close
