#!/usr/bin/env ruby

require './configure.rb'

active_domains = conn.list_domains

begin
  dom = @conn.lookup_domain_by_id(active_domains.first)
rescue
  puts 'There is not found avtive domains'
end

dom.block_stats(path)