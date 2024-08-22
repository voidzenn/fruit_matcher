# frozen_string_literal: true

require "ruby2d"
require_relative "../custom_classes/button"
require_relative "../concerns/game_display"

class PlayButton
  include GameDisplay

  def initialize next_event
    @next_event = next_event
    @width = 200
    @height = 60

    show_button
  end

  def mouse_down mouse_location
    unless @button.nil?
      @button.mouse_location = mouse_location
      handle_click
    end
  end

  def mouse_up mouse_location
  end

  private

  attr_reader :next_event, :width, :height

  def show_button
    @button = Button.new(
      label: "Play", x: center_x, y: center_y, width: width, height: height
    )
    @button.draw
  end

  def center_x
    (Window.width - width) / 2
  end

  def center_y
    (Window.height - height) / 2
  end

  def handle_click
    if @button.is_clicked?
      @button.hide
      next_event.call
    end
  end
end
