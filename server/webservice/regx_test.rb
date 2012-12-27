#!/opt/local/bin/ruby
$LOAD_PATH.unshift("./lib")
require 'json'
require "./lib/search2.rb"

$FN_LIST = [ 
  "This/Is/A/Test/Star Wars 1977.mp4",
  "/test/Star Wars II.mp4",
  "/test/this/Star Wars (1980).mp4",
  "/this/is/a/test/Misfits/Season 2/Ep1.mp4",
  "/a/nother/season/Misfits/Season 2/Ep1.mp4",
  "Misfits/Sea 2/Episode 1.mp4",
  "Misfits/Season 2/e01.mp4",
  "Misfits/S2/Ep1.mp4",
  "Misfits/Series 2/1.mp4",
  "Misfits/Season 2 Episode 1.mp4",
  "Misfits/Sea 2 Ep 1.mp4",
  "Misfits/S 02 EP 1.mp4",
  "Misfits/2x1.mp4",
  "Misfits/S02E01.mp4",
  "Misfits/Sea 2 E1 - .mp4",
  "Misfits S02E01.mp4",
  "Misfits 02 x 01.mp4",
  "Misfits 2x1.mp4",
  "Misfits - S02E01 - .mp4",
  "Misfits-Sea 2 E1 - .mp4",
  "Misfits/1.mp4",
  "Misfits/e1.mp4"
]

$DEBUG_POP = true

$FN_LIST.each do |fn|
  res = Search.search(fn)
  puts res
end