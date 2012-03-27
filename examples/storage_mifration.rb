#!/usr/bin/env ruby

require './configure.rb'

# http://wiki.qemu.org/Features/SnapshotsMultipleDevices
# http://www.redhat.com/archives/libvir-list/2012-March/msg01171.html
#My plan is to have everything in this RFC coded up in the next couple of
#days (hopefully no later than Thursday); this has missed the feature
#freeze for 0.9.11, so it should not be applied upstream until after the
#weekend release, as one of the first patches for 0.9.12.  Backport-wise,
#    the new flags can be backported as far back as the 0.9.10 .so API, but
#the new virDomainBlockCopy() API cannot be exported when doing a
#backport without breaking .so versions (although it's implemenation can
#be used internally).
