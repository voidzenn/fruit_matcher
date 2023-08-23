# fronze_string_literal: true

require "ruby2d"

class CRectangle < Rectangle
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
