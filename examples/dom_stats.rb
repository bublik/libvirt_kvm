#!/usr/bin/env ruby

require './configure.rb'

#active_domains = @conn.list_domains

begin
  dom = @conn.lookup_domain_by_name('hw21tb33hlum1a')
rescue
  puts 'There is not found avtive domains'
end
puts @conn.discover_storage_pool_sources.inspect

#puts dom.block_stats('/dev/onapp-pboo5tdyyvbm71/l8v6gan17uxrnj').inspect


@conn.close