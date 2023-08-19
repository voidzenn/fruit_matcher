require "ruby2d"

class CText
  def initialize text:, x:, y:, size:, color: "white"
    @text = text
    @x = x
    @y = y
    @size = size
    @color = color
  end

  def draw
    Text.new(
      text, x: x, y: y, size: size
    )
  end

  private

  attr_reader :text, :x, :y, :size, :color

end
