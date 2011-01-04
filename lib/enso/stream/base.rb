module Stream
  class Base
    def tick
      raise NotImplementedError
    end 
    
    def tick_quantum
      5
    end 

    def format_items(items)
      items.each do |item|
        format_item(item)
      end 
    end 

    def format_item(item)
      item
    end 

    def format_error(error)
      error
    end 
    
  end 
end 

