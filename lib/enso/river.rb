class River

  def initialize
    @streams = []
  end 

  def register_stream(stream)
    @streams << stream        
  end 

  def tick
    @streams.map(&:tick).flatten.each do |item|
      output item
    end 
  end 

  def output(item)
    puts item
  end 
  
  def run
    loop do
      tick
      sleep 1
    end 
  end 
  
end 
