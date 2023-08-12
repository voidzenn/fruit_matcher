require "ruby2d"

class CustomRectangle < Rectangle
  def initialize x:, y:, width:, height:, color:
    @x = x
    @y = y
    @width = width
    @height = height
    @color = color
  end

  def draw
    Rectangle.new(
      x: @x, y: @y, width: @width, height: @height,
      color: @color
    )
  end
end
