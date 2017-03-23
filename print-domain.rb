#!/usr/bin/env ruby
require 'rubygems'
require 'ccsv'
require 'uri'
require 'public_suffix'

header = true
Ccsv.foreach(ARGV[0]) do |values|
  $stderr.puts(values)
  if header == true
    header = false
    next
  end
  field2 = values[2]
  $stderr.printf("2nd record:%s\n",field2) # values[2] to get the URI
  if field2.index("https://") != 0 && field2.index("http://") != 0
    $stderr.printf("SKIPPING non HTTP and non HTTP FIELD2:%s; FIELD3:%s\n", field2, values[3])
    next
  end
  uri = URI.parse(values[2])
  begin
    domain = PublicSuffix.parse(uri.host)
    puts domain.domain
  rescue PublicSuffix::DomainNotAllowed
    $stderr.printf("PublicSuffix::DomainNotAllowed^^^ URI:%s\n", uri.host)
  end
end
