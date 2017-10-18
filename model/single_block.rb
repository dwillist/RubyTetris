require_relative 'Pos.rb'

class Single_Block

  attr_accessor :pos, :color

  def initialize(pos,color)
    @pos = pos
    @color = color
  end

  def move!(delta_pos)
    @pos.x += delta_pos.x
    @pos.y += delta_pos.y
    self
  end

  def move(delta_pos)
    return Single_Block.new(Pos.new(@pos.y + delta_pos.y,@pos.x + delta_pos.x),@color)
  end

  def intersect(otherBlock)
    @pos == otherBlock.pos
  end

  def ==(o)
    o.class == self.class && @pos == o.pos && @color == o.color
  end

end
