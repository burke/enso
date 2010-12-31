r = lambda do |f|
  require File.join(File.dirname(__FILE__), "enso", f)
end 
 
r["stream"]
r["stream/base"]
r["stream/dummy"]
r["river"]

if __FILE__ == $0
  stream = Stream::Dummy.new
  river  = River.new
  river.register_stream(stream)
  river.run
end 

