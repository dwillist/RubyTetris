require 'gosu'
require_relative 'model/pos'
require_relative 'model/board'
require_relative 'model/single_block'

class Controller < Gosu::Window
  def initialize(height=800,width=400,speed = 40)
    super width,height
    self.caption = "Tutorial Game"
    #@block_image = Gosu::Image.new('media/block.png')
    @player_move = Pos.new(0,0)
    @board_inst = Board.new()
    @grid_px_width = width/@board_inst.x_dim
    @grid_px_height = height/@board_inst.y_dim
    @game_over_limit = @grid_px_height * @board_inst.y_lim
    @ticks = 1
    @tick_mod = [10,speed].max # this must be greater than the rotate_mod and move_mod speed
    @move_mod = 5
    @rotate_mod = 10
    @player_rotate = false
    @height = height
    @width = width
    @font = Gosu::Font.new(20)
  end

  def handle_piece_movement delta_pos
    return unless @board_inst.active_piece
    if @board_inst.move_ends_active_peice(delta_pos)
      @board_inst.add_to_pile(@board_inst.active_piece)
      @board_inst.active_piece = nil
      @board_inst.adjust_rows!
    else
      @board_inst.move_active_piece delta_pos
    end
  end

  def update
    if(@board_inst.game_over)
      return false
    end
    @player_move = Pos.new(0,0)
    if Gosu.button_down? Gosu::KB_LEFT and @board_inst.active_piece and (@ticks % @move_mod == 0)
      @player_move.x = -1
      # move piece left
    elsif Gosu.button_down? Gosu::KB_RIGHT and @board_inst.active_piece and (@ticks % @move_mod == 0)
      @player_move.x = 1
      # move piece right
    elsif Gosu.button_down? Gosu::KB_DOWN and @board_inst.active_piece and (@ticks % @move_mod == 0)
      @player_move.y = 1
    elsif Gosu.button_down? Gosu::KB_SPACE and @board_inst.active_piece and (@ticks % @rotate_mod == 0)
      @board_inst.rotate_right_active_piece
    end
    handle_piece_movement @player_move
    if @board_inst.active_piece == nil
      @board_inst.active_piece = Factory_Array.sample.make
      @board_inst.active_piece.move!(Pos.new(0,@board_inst.x_dim/2))
    else # we have an active piece
      if @ticks % @tick_mod == 0
        @ticks = 0
        handle_piece_movement Pos.new(1,0)
      end
      @ticks += 1
    end
  end

  def draw_block y,x,color
    Gosu::draw_rect(x * @grid_px_width,y * @grid_px_height,@grid_px_width,@grid_px_height,color)
  end

  def draw_score
    @font.draw("Score: #{@board_inst.score}", 10, 10, 1, 1.0, 1.0, Gosu::Color::WHITE)
  end

  def draw_background
    Gosu::draw_rect(0,0,@width,@height,Gosu::Color.argb(0xff_000000))
  end

  def draw_game_over
    @font.draw("Game Over", width/2 - 50, height/2 - 10, 1, 2.0, 2.0, Gosu::Color::WHITE)
  end

  def draw # set this to only happen so many times per second
    draw_background
    draw_score
    @board_inst.pile_array.each_with_index  do |row,ri|
      row.each_with_index do |block,eli|
        draw_block(ri,eli,block) if block
      end
    end
    if @board_inst.active_piece
      @board_inst.active_piece.each_with_pos do |elem,pos|
        draw_block(pos.y,pos.x,elem) if elem
      end
    end
    if @board_inst.game_over
      draw_game_over
    end
  end
end

