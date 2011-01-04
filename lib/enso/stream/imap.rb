require 'net/imap'

module Stream
  class IMAP < Base

    def initialize(domain, port, ssl, username, password)
      @domain = domain
      @port = port
      @ssl = ssl
      @username = username
      @password = password
      
      @imap = Net::IMAP.new(@domain, @port, @ssl)
      @imap.login(@username, @password)
      @imap.select("INBOX")

      @top_mid = @imap.search('ALL').last
      @top_uid = @imap.fetch(@top_mid, 'UID')[0].attr['UID']
    end 

    def tick_quantum
      15
    end 
    
    def tick
      mids = []
      query = "UID #{@top_uid}:*"
      @imap.check
      @imap.search(query).each do |message_id|
        next if message_id == @top_mid 
        @top_mid = [@top_mid, message_id].max
        mids << message_id.to_i
      end 
      messages = mids.any? ? @imap.fetch(mids, "(UID ENVELOPE)") : []
      @top_uid = [@top_uid, messages.map{|m|m.attr['UID']}.max].compact.max
 
      messages.map{|m|format_message(m.attr['ENVELOPE'])}
    end 

    def format_message(msg)
      {
        'from'    => "#{msg.sender[0].mailbox}@#{msg.sender[0].host}",
        'subject' => "#{msg.subject}"
      }
    end 

  end 
end 

