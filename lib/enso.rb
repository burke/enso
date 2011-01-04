r = lambda do |f|
  require File.join(File.dirname(__FILE__), "enso", f)
end 
 
r["stream"]
r["stream/base"]
r["stream/dummy"]
r["stream/rss"]
r["stream/imap"]
r["stream/twitter"]
r["river"]

if __FILE__ == $0
  streams = [
    Stream::RSS.new('http://www.reddit.com/r/all/new.xml'),
  ]
  river = River.new
  streams.each do |stream|
    river.register_stream(stream)
  end 
  river.run
end 

