require "ruby2d"
require_relative "c_rectangle"
require_relative "c_text"

class Button
  attr_accessor :mouse_location

  def initialize label:, x:, y:, width:, height:, color: "black"
    @label = label
    @x = x
    @y = y
    @width = width
    @height = height
    @color = color
  end

  def draw
    draw_button
    draw_text
  end

  def is_clicked?
    if (mouse_location[0] >= x && mouse_location[0] <= (x + width)) &&
       (mouse_location[1] >= y && mouse_location[1] <= (y + height))
      return true
    end
  end

  private

  attr_reader :label, :x, :y, :width, :height, :color

  def draw_button
    c_rect = CRectangle.new(
      x: x, y: y, width: width, height: height, color: color
    )
    c_rect.draw
  end

  def draw_text
    text_size = 25
    c_text = CText.new text: label, x: center_x(text_size), y: center_y(text_size), size: text_size
    c_text.draw
  end

  def center_x size
    (x - size) + (width / 2)
  end

  def center_y size
    margin_top = 5
    (y - size + margin_top) + (height / 2)
  end
end
