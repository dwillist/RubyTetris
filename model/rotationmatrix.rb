
class Rotation_Matrix
  attr_accessor :vals
  def initialize(a,b,c,d)
    @vals = [[a,b],[c,d]]
    @a = vals[]
  end

  def a
    @vals[0][0]
  end
end

# test weather or not we can assign through function

R = Rotation_Matrix(1,2,3,4)
puts R.vals
R.a = 5
puts  R.vals

