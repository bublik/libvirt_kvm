#!/usr/bin/env ruby

require './configure.rb'
# our RAW format does not supported snapshot
#(possible with qcow2 and qed)
#<disk snapshot='no|external|internal' persistent='yes|no'>...</disk>

dom_name = 'w7jtb3e0baine9'
dom = @conn.lookup_domain_by_name(dom_name)

snapxml = "<domainsnapshot>
  <name>Test-snap</name>
  <description>Snapshot test1</description>
  <disk name='hda' snapshot='external'>
      <source file='/dev/onapp-v1vgz2q0yevwzt/dkqmmd9yzf87gz-manual-backup'/>
  </disk>
</domainsnapshot>"
begin
  puts dom.snapshot_create_xml(snapxml)
rescue => e
  puts e
end

@conn.close
