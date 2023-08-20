require "ruby2d"

class CText
  def initialize text:, x:, y:, size:, color: "white"
    @text = text
    @x = x
    @y = y
    @size = size
    @color = color
  end

  class << self
    def text_width width
      Text.new(width).width
    end

    def text_height text
      Text.new(text).height
    end
  end

  def draw
    Text.new(
      text, x: x, y: y, size: size, color: color
    )
  end

  private

  attr_reader :text, :x, :y, :size, :color

end
