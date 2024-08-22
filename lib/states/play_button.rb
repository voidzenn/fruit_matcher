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
    click_event
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

  def click_event
    Window.on :mouse_down do |event|
      unless @button.nil?
        @button.mouse_location = [event.x, event.y]
        handle_click
      end
    end
  end
end
