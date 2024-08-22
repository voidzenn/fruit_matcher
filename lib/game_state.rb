# frozen_string_literal: true

require "ruby2d"
require "debug"
require_relative "custom_classes/screen"
require_relative "custom_classes/button"
require_relative "custom_classes/c_rectangle"
require_relative "states/play_button"
require_relative "concerns/game_display"
require_relative "asset"

class GameState
  include GameDisplay

  def display_sequence state, next_event
    case state
    when :play_button
      PlayButton.new next_event
    when :dimension_selection
      handle_play_button next_event
    when :show_images
    when :image_selection
    when :ended
    end
  end
end
