require 'eventmachine'

class River

  def initialize
    @streams  = []
    @estreams = []
  end 

  def register_stream(stream)
    @streams << stream        
  end 

  def tick
    @streams.map(&:tick).flatten.each do |item|
      output item
    end 
  end 

  def handle_item(stream, item)
    puts item.inspect
  end 
  
  def handle_items(stream, items)
    items.each do |item|
      handle_item(stream, item)
    end 
  end 
  
  def handle_error(stream, error)
    puts error
  end 

  def handle_reconnect(stream, timeout)
  end 
  
  def run
    EventMachine.run do
      @streams.each do |stream|
        if stream.respond_to?(:eventstream)
          es = stream.eventstream
          @estreams << es
          es.each_item    { |item|    handle_item(stream,  stream.format_item(item))   }
          es.on_error     { |error|   handle_error(stream, stream.format_error(error)) }
          es.on_reconnect { |timeout| handle_reconnect(stream, timeout) }
        elsif stream.respond_to?(:eventcode)
          stream.eventcode
        elsif stream.respond_to?(:tick)
          operation = proc { stream.tick }
          callback  = proc { |result| 
            handle_items(stream, stream.format_items(result))
          }
          EM.defer(operation, callback)
          EM.add_periodic_timer(stream.tick_quantum) do
            EM.defer(operation, callback)
          end 
        else 
          raise "Invalid Stream Object"
        end 
      end 
      trap('TERM') {  
        @estreams.map(&:stop)
        EventMachine.stop if EventMachine.reactor_running? 
      }
    end 
  end 
  
end 
