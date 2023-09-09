# frozen_string_literal: true

require "ruby2d"
require_relative "lib/game"
require_relative "lib/custom_classes/screen"

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
BG_COLOR = "white"
TITLE = "Matcher"

def run
  Screen.set width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: TITLE, background: BG_COLOR

  game = Game.new SCREEN_WIDTH, SCREEN_HEIGHT

  if game.running?
    update do
      game.update
    end

    render do
    end

    on :mouse_down do |event|
      game.mouse_location = [event.x, event.y]
      game.handle_click
    end

    set start_time: Time.now

    Screen.show
  end
end

run
