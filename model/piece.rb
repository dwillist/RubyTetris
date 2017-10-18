require_relative 'single_block'
require_relative 'pos'


class Piece

  attr_reader :matrix,:rep_pos,:max_dim, :x_dim, :y_dim, :size

  def self.block_array_conversion(block_array)
    min_x = block_array.map {|i| i.pos.x}.min
    max_x = block_array.map {|i| i.pos.x}.max
    min_y = block_array.map {|i| i.pos.y}.min
    max_y = block_array.map {|i| i.pos.y}.max
    size = block_array.length
    x_dim = max_x - min_x + 1
    y_dim = max_y - min_y + 1
    max_dim =  [y_dim,x_dim].max
    matrix = Array.new(max_dim){ Array.new(max_dim, false) }
    rep_pos = Pos.new(0,0)
    block_array.each do |elem|
      # for some wierd reason these assingments are needed before array access... not sure why
      ypos = elem.pos.y - min_y
      xpos = elem.pos.x - min_x
      matrix[ypos][xpos] = elem.color
    end
    return matrix, x_dim, y_dim, rep_pos, size
  end


  def initialize(matrix, x_dim, y_dim, rep_pos, size)
    @size = size
    @x_dim = x_dim
    @y_dim = y_dim
    @max_dim = [@y_dim,@x_dim].max
    @rep_pos = rep_pos
    @matrix = matrix
    #centre our matrix to make rotations more natural
  end

  def move(delta_pos)
    Piece.new(@matrix,
              @x_dim ,
              @y_dim,
              Pos.new(@rep_pos.y + delta_pos.y, @rep_pos.x + delta_pos.x),
              @size)
  end

  def move!(delta_pos)
    @rep_pos = Pos.new(@rep_pos.y + delta_pos.y, @rep_pos.x + delta_pos.x)
  end

  def each_with_pos
    @matrix.each_with_index do |row,r_i|
      row.each_with_index do |elem,elem_i|
        pos_to_yield = Pos.new(@rep_pos.y + r_i,@rep_pos.x + elem_i)
        yield elem,pos_to_yield,r_i,elem_i if elem
      end
    end
  end

  def rotate_right # could be made a bit more efficent at the cost of readability
    temp_matrix = Array.new(@max_dim){Array.new(@max_dim,false)}
    each_with_pos {|elem,pos,row_i,col_i| temp_matrix[@max_dim-col_i-1][row_i] = @matrix[row_i][col_i]}
    Piece.new(temp_matrix,@x_dim,@y_dim,@rep_pos,@size)
  end

  def rotate_right!
    @matrix = rotate_right.matrix
  end


  def rotate_left # should probably change this to pass a proc to a general rotate
    3.times {rotate_right}
  end

  def pos_intersect(pos)
    each_with_pos {|elem,cur_pos| return true if pos == cur_pos }
    false
  end
end
