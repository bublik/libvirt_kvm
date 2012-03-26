#!/usr/bin/env ruby

require './configure.rb'

#active_domains = @conn.list_domains
# TODO
# add get stats information
begin
  dom = @conn.lookup_domain_by_name('hw21tb33hlum1a')
rescue
  puts 'There is not found avtive domains'
end

@conn.close