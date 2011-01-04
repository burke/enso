require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

module Stream
  class RSS < Base

    def initialize(url, tick_quantum=60)
      @url = url
      @tick_quantum = tick_quantum
    end 
    
    attr_reader :tick_quantum

    def tick
      content = ""
      open("#{@url}?#{Time.now.to_i}") do |s| content = s.read end
      rss = ::RSS::Parser.parse(content, false)

      max_date = rss.items.map(&:date).max || Time.now
      
      if @date.nil?  # Don't show feeds on initial run.
        @date = max_date
        return []
      end 

      items = rss.items.select do |item|
        @date.nil? or item.date > @date
      end 

      @date = max_date

      items.map do |item|
        {'title' => item.title}
      end 
      
    end 

  end 
end 



