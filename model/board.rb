require_relative 'piece_factories'
require_relative 'piece'
require_relative 'pos'
#should be noted that all accese to @pile_array are of the form [y][x]

class Board

  attr_reader :x_dim, :y_dim, :y_lim, :pile_array, :game_over, :score, :factories
  attr_accessor :active_piece

  def initialize(y_dim=16,x_dim=8,y_lim=1)
    @x_dim = x_dim
    @y_dim = y_dim
    @y_lim = y_lim
    @pile_array = Array.new(@y_dim){ Array.new(@x_dim, nil) }
    @game_over = false
    @active_piece = nil
    @score = 0
  end

  def valid_pos(pos)
    (0 <= pos.x && pos.x < @x_dim) && (0 <= pos.y && pos.y < @y_dim) && !@pile_array[pos.y][pos.x]
  end

  def valid_piece_pos(piece)
    piece.each_with_pos {|elem,pos| return false unless (!elem || valid_pos(pos))}
    true
  end

  def piece_ends_game(piece)
    piece.each_with_pos {|elem,pos| return true if elem && pos.y < @y_lim}
    false
  end

  def piece_stop_falling piece
    return false unless piece
    piece_after_move = piece.move(Pos.new(1, 0))
    # test for collision with end of board
    piece_after_move.each_with_pos do |elem,pos|
      return true if elem && (pos.y == @y_dim || @pile_array[pos.y][pos.x])
    end
    false
  end

  def active_stop_falling
    piece_stop_falling @active_piece
  end

  def add_to_pile(active_piece)
    @game_over = piece_ends_game(active_piece)
    active_piece.each_with_pos do |elem,pos|
      return false unless valid_pos(pos)
      @pile_array[pos.y][pos.x] = elem if elem
    end
    true
  end

  def move_ends_active_peice(delta_pos)
    return false unless delta_pos.x == 0
    temp_peice = @active_piece.move delta_pos
    temp_peice.each_with_pos do |elem,pos|
      return true if elem && (pos.y == @y_dim || @pile_array[pos.y][pos.x])
    end
    false
  end

  def adjust_rows!
    deleted_rows = 0
    @pile_array.delete_if { |row| deleted_rows += 1 unless row.include? nil }
    @score += deleted_rows
    @pile_array = Array.new(deleted_rows){Array.new(@x_dim, nil)} + @pile_array
  end

  def move_active_piece(delta_pos)
    temp_piece = @active_piece ? @active_piece.move(delta_pos) : nil
    @active_piece = temp_piece if (temp_piece && valid_piece_pos(temp_piece))
  end

  def rotate_right_active_piece
    temp_piece = @active_piece ? @active_piece.rotate_right : nil
    @active_piece.rotate_right! if @active_piece && valid_piece_pos(temp_piece)

  end
end
