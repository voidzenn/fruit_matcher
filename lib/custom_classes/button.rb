# frozen_string_literal: true

require "ruby2d"
require_relative "c_rectangle"
require_relative "c_text"

class Button
  attr_accessor :mouse_location

  def initialize label:, x:, y:, width:, height:, color: "black"
    @label = label
    @btn_x = x
    @btn_y = y
    @btn_width = width
    @btn_height = height
    @color = color
  end

  def draw
    draw_button
    draw_text
  end

  def is_clicked?
    if (mouse_location[0] >= btn_x && mouse_location[0] <= (btn_x + btn_width)) &&
       (mouse_location[1] >= btn_y && mouse_location[1] <= (btn_y + btn_height))
      return true
    end
  end

  private

  attr_reader :label, :btn_x, :btn_y, :btn_width, :btn_height, :color

  def draw_button
    CRectangle.new(
      x: btn_x, y: btn_y, width: btn_width, height: btn_height, color: color
    ).draw
  end

  def draw_text
    text_size = 25
    CText.new(text: label, x: center_x, y: center_y, size: text_size).draw
  end

  def center_x
    text_width = CText.text_width label
    # TODO: Should fix the issue with text position x
    (btn_x + (btn_width - text_width) / 2) - 5 # Added 5 to position it center
  end

  def center_y
    text_height = CText.text_height label
    # TODO: Should fix the issue with text position y
    (btn_y + (btn_height - text_height) / 2) - 2 # Added 2 to position it center
  end
end
