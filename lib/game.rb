require "ruby2d"
require_relative "game_state"
require_relative "custom_classes/button"

# Game states
INIT = :init
PLAY_BUTTON = :play_button
DIMENSION_SELECTION = :dimension_selection
ENDED = :ended

class Game
  attr_accessor :mouse_location

  def initialize screen_width, screen_height
    @current_state = INIT
    @game_state = GameState.new screen_width, screen_height
    @current_game_state = nil
    @mouse_location = nil
  end

  def running?
    @current_state != ENDED
  end

  def update
    case @current_state
    when INIT
      @current_state = PLAY_BUTTON
    when PLAY_BUTTON
      @current_game_state = @game_state.play_button
    when DIMENSION_SELECTION
      @current_game_state = @game_state.dimension_selection
    when ENDED
    end
  end

  def handle_click
    case @current_state
    when PLAY_BUTTON
      callback = -> { @current_state = DIMENSION_SELECTION; Screen.clear }
      @current_game_state.handle_click mouse_location, callback: callback
    when DIMENSION_SELECTION
    end
  end
end
