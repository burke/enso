require 'twitter/json_stream'

class TwitterAuther
  CONSUMER_KEY    = "2dijIQYGiq3ztPAAVyrGaw"
  CONSUMER_SECRET = "sePRjpUVeGT6R0D8kped6ttz70zNJg1LgrQ2Y"
  
  def doit
    c = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, { :site => 'http://twitter.com'})
    rt = c.get_request_token

    open "https://api.twitter.com/oauth/authorize?oauth_token=#{rt.token}"
    pin = (get pin)
    
    at = rt.get_access_token(:oauth_verifier => pin)
    [at.key, at.secret]
  end 
end 

EventMachine::run {
  stream = Twitter::JSONStream.connect(
    :path    => '/1/statuses/filter.json',
    :oauth => {
      :consumer_key    => TwitterAuther::CONSUMER_KEY,
      :consumer_secret => TwitterAuther::CONSUMER_SECRET,
      :access_key      => "16598344-cvgm9HtT86DaNeOG1fjvcEASNQ6mECA4HqSWT2DqQ",
      :access_secret   => "RL2DuxYIp6yrWK7SCMJgUtyJ5rVlybdMSsSiuHnsj1M"
    },
    :path    => '/2/user.json',
    :host    => 'userstream.twitter.com',
    :ssl     => true
  )
    
  stream.each_item do |item|
    puts item
  end

  stream.on_error do |message|
    puts message
  end
  
  trap('TERM') {  
    stream.stop
    EventMachine.stop if EventMachine.reactor_running? 
  }
}
puts "The event loop has ended"
