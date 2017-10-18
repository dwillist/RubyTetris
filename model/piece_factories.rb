require_relative 'piece.rb'
require_relative 'pos.rb'
require_relative 'single_block'
require 'gosu'

class BaseFactory
  def initialize pos_list,color
    @pos_list = pos_list
    @color = color
  end

  def make
    block_list = []
    @pos_list.each { |p| block_list.push Single_Block.new(p,@color )}
    temp = Piece.block_array_conversion(block_list)
    Piece.new(*temp) #splat operator * used
  end
end



Lfactory = BaseFactory.new([Pos.new(0,0),Pos.new(1,0),Pos.new(0,1),Pos.new(0,2)],
                       Gosu::Color.argb(0xff_00ffff))

RevLfactory = BaseFactory.new([Pos.new(1,0),Pos.new(0,0),Pos.new(1,1),Pos.new(1,2)],
                          Gosu::Color.argb(0xff_ff0000))

Ifactory = BaseFactory.new([Pos.new(0,0),Pos.new(0,1),Pos.new(0,2),Pos.new(0,3)],
                       Gosu::Color.argb(0xff_808080))

Zfactory = BaseFactory.new( [Pos.new(0,0),Pos.new(0,1),Pos.new(1,1),Pos.new(1,2)],
               Gosu::Color.argb(0xff_00ff00) )

RevZfactory = BaseFactory.new([Pos.new(1,0),Pos.new(1,1),Pos.new(0,1),Pos.new(0,2)],
                          Gosu::Color.argb(0xff_ff00ff))

Factory_Array = [Lfactory,RevLfactory,Ifactory,Zfactory,RevZfactory]
