require 'twitter/json_stream'
require 'json'

module Stream
  class Twitter < Base
    CONSUMER_KEY    = "2dijIQYGiq3ztPAAVyrGaw"
    CONSUMER_SECRET = "sePRjpUVeGT6R0D8kped6ttz70zNJg1LgrQ2Y"

    def initialize(access_key, access_secret)
      @access_key = access_key
      @access_secret = access_secret
    end 
    
    def obtain_auth
      c = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, { :site => 'http://twitter.com'})
      rt = c.get_request_token
   
      open "https://api.twitter.com/oauth/authorize?oauth_token=#{rt.token}"
      pin = (get pin)
      
      at = rt.get_access_token(:oauth_verifier => pin)
      [at.key, at.secret]
    end 
    
    def eventstream
      ::Twitter::JSONStream.connect(
        :path    => '/1/statuses/filter.json',
        :oauth => {
          :consumer_key    => CONSUMER_KEY,
          :consumer_secret => CONSUMER_SECRET,
          :access_key      => @access_key,
          :access_secret   => @access_secret
        },
        :path    => '/2/user.json',
        :host    => 'userstream.twitter.com',
        :ssl     => true
        )
    end     

    def format_item(item)
      JSON.parse(item)
    end 
    
  end 
end 

