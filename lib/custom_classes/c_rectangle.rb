# frozen_string_literal: true

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
    @rect = Rectangle.new(
      x: @x, y: @y, width: @width, height: @height,
      color: @color
    )
  end

  def hide
    @rect.remove
  end

  def show
    @rect.add
  end
end
