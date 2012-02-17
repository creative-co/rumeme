# from ruby 1.8.7 source

class Generator
  include Enumerable

  # Creates a new generator either from an Enumerable object or from a
  # block.
  #
  # In the former, block is ignored even if given.
  #
  # In the latter, the given block is called with the generator
  # itself, and expected to call the +yield+ method for each element.
  def initialize(enum = nil, &block)
    if enum
      @block = proc { |g|
	enum.each { |x| g.yield x }
      }
    else
      @block = block
    end

    @index = 0
    @queue = []
    @cont_next = @cont_yield = @cont_endp = nil

    if @cont_next = callcc { |c| c }
      @block.call(self)

      @cont_endp.call(nil) if @cont_endp
    end

    self
  end

  # Yields an element to the generator.
  def yield(value)
    if @cont_yield = callcc { |c| c }
      @queue << value
      @cont_next.call(nil)
    end

    self
  end

  # Returns true if the generator has reached the end.
  def end?()
    if @cont_endp = callcc { |c| c }
      @cont_yield.nil? && @queue.empty?
    else
      @queue.empty?
    end
  end

  # Returns true if the generator has not reached the end yet.
  def next?()
    !end?
  end

  # Returns the current index (position) counting from zero.
  def index()
    @index
  end

  # Returns the current index (position) counting from zero.
  def pos()
    @index
  end

  # Returns the element at the current position and moves forward.
  def next()
    if end?
      raise EOFError, "no more elements available"
    end

    if @cont_next = callcc { |c| c }
      @cont_yield.call(nil) if @cont_yield
    end

    @index += 1

    @queue.shift
  end

  # Returns the element at the current position.
  def current()
    if @queue.empty?
      raise EOFError, "no more elements available"
    end

    @queue.first
  end

  # Rewinds the generator.
  def rewind()
    initialize(nil, &@block) if @index.nonzero?

    self
  end

  # Rewinds the generator and enumerates the elements.
  def each
    rewind

    until end?
      yield self.next
    end

    self
  end
end
