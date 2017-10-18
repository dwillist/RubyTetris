class Pos

  attr_accessor :x, :y

  def initialize(y,x)
    @x = x
    @y = y
  end

  def ==(o)
    self.class == o.class && @x == o.x && @y == o.y
  end

  def matrixMult rotation_matrix
    #matrix needs to be 2x2

  end

end
