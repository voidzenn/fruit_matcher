# fronze_string_literal: true

require "ruby2d"
require_relative "game_state"
require_relative "custom_classes/button"

# Game states
INIT = :init
PLAY_BUTTON = :play_button
DIMENSION_SELECTION = :dimension_selection
IMAGE_SELECTION = :image_selection
ENDED = :ended

class Game
  attr_accessor :mouse_location

  def initialize screen_width, screen_height
    @current_state = INIT
    @game_state = GameState.new screen_width, screen_height
    @current_game_state = nil
    @mouse_location = nil
    @selected_dimension = nil
  end

  def running?
    @current_state != ENDED
  end

  def update
    case @current_state
    when INIT
      @current_state = PLAY_BUTTON
    when PLAY_BUTTON
      @current_game_state ||= GameStatePlayButton.new  @game_state
    when DIMENSION_SELECTION
      @current_game_state ||= GameStateDimensionSelection.new @game_state
    when IMAGE_SELECTION
      @current_game_state ||= GameStateImageSelection.new @game_state, @selected_dimension
    when ENDED
    end
  end

  # Handle click will be called in the main.rb when there is click events.
  # Each state can have different process based on how it is used.
  def handle_click
    case @current_state
    when PLAY_BUTTON
      # Passing callback helps in managing the state inside Game class
      callback = -> { @current_state = DIMENSION_SELECTION;
                      # We should assign nil in order for the ||= to work when
                      # assigning new state.
                      @current_game_state = nil;
                      # Clears the last state drawn/shown.
                      Screen.clear }
      game_state_handle_click callback: callback
    when DIMENSION_SELECTION
      @selected_dimension = game_state_handle_click

      unless @selected_dimension.nil?
        @current_state = IMAGE_SELECTION
        @current_game_state = nil
        Screen.clear
      end
    when IMAGE_SELECTION
    end
  end

  private

  def game_state_handle_click callback: nil
    if callback.nil?
      @current_game_state.handle_click mouse_location
    elsif
      @current_game_state.handle_click mouse_location, callback: callback
    end
  end
end
