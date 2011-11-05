class Generator
  attr_reader :index
  
  def initialize(enum = nil)
    if enum
      @array = enum.to_a
    else
      @array = Array.new
      yield self
    end
    @index = 0
  end
  
  def current
    raise EOFError unless next?
    @array[@index]
  end
  
  def next
    value = current
    @index += 1
    return value
  end
  
  def next?
    return @index < @array.length
  end
  
  def rewind
    @index = 0
    self
  end
  
  def each(&block)
    @array.each(&block)
  end
  
  def yield(value)
    @array << value
  end
  
  def pos
    return @index
  end
  
  def end?
    return !next?
  end
end