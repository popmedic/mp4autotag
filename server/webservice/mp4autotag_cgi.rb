#!/usr/local/bin/ruby

require 'cgi'
require 'uri'

$LOAD_PATH.unshift("./lib")
require 'json'

require './lib/search.rb'

$DEBUG_POP = false
$OUT_FMT = '.json'

cgi = CGI.new

#log the users coming in...
File.open('ulog.txt','a+') do |f|
  f.write("REMOTE_ADDR: %s\tQUERY_STRING: %s\n" % [cgi.remote_addr, cgi.query_string])
end

search_str = cgi['search']
if(search_str == "")
  cgi.out("text/html") { File.read('mp4autotag_cgi.html') }
  exit
end

use_itunes = cgi['use_itunes'].to_i
  
res = Search.search(URI.unescape(search_str), use_itunes)

#log a non-hit...
if(res.count == 0)
  File.open('misslog.txt','a+') do |f|
    f.write("%s\n" % [search_str])
  end
end

if(/\.json/i.match($OUT_FMT) != nil)
  cgi.out("text/plain") { res.to_json }
elsif(/\.html/i.match($OUT_FMT) != nil)
  cgi.out("text/html") { Search.to_html(res) }
else
   cgi.out("text/plain") { res.to_json }
end