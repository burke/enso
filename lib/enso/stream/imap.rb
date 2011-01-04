require 'net/imap'

module Stream
  class IMAP < Base

    def initialize(domain, port, ssl, username, password)
      @imap = Net::IMAP.new(domain, port, ssl)
      @imap.login(username, password)
      @imap.select("INBOX")
      
      @imap.add_response_handler proc { |resp|
        if resp.name == "EXISTS"
          fetch_message(resp.data)
        end 
      }
    end 

    def tick_quantum
      15
    end 

    def fetch_message(data)
      @imap.fetch([data], "(ENVELOPE)")
    end 
    
    def tick
      @imap.noop
    end 

    def format_message(msg)
      {
        'from'    => "#{msg.sender[0].mailbox}@#{msg.sender[0].host}",
        'subject' => "#{msg.subject}"
      }
    end 

  end 
end 

