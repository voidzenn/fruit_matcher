# frozen_string_literal: true

require "ruby2d"
require_relative "../custom_classes/button"
require_relative "../concerns/game_display"
require_relative "../asset"

class DimensionSelection
  include GameDisplay

  attr_accessor :dimension

  def initialize next_event
    @next_event = next_event
    @dimension = nil

    show_button
  end

  def mouse_down mouse_location
    unless @btn_1.nil? && @btn_2.nil?
      @btn_1.mouse_location = mouse_location
      @btn_2.mouse_location = mouse_location
      handle_click
    end
  end

  def mouse_up mouse_location
  end

  private

  attr_reader :next_event

  def show_button
    width = 150
    @height = 60

    new_y = screen_y_center

    @btn_1 = Button.new label: FOUR_BY_FOUR, x: position_x(1), y: new_y, width: width, height: height
    @btn_1.draw
    @btn_2 = Button.new label: SIX_BY_SIX, x: position_x(4), y: new_y, width: width, height: height
    @btn_2.draw
  end


  def handle_click
    if @btn_1&.is_clicked?
      hide_buttons
      @dimension = FOUR_BY_FOUR
      next_event.call
    elsif @btn_2&.is_clicked?
      hide_buttons
      @dimension = SIX_BY_SIX
      next_event.call
    end
  end

  def position_x column_position
    # Divide width by 6 to have 6 columns
    if column_position <= 6
      column_size = Window.width / 6
      position = column_size * column_position

      return position
    end
  end

  def screen_y_center
    (Window.height / 2) - @height
  end

  def hide_buttons
    @btn_1.hide
    @btn_2.hide
  end
end
