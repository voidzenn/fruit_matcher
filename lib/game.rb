# frozen_string_literal: true

require "ruby2d"
require "aasm"
require_relative "game_state"
require_relative "custom_classes/button"

class Game
  include AASM

  attr_accessor :mouse_location

  def initialize screen_width, screen_height
    @game_state = State::GameState.new screen_width, screen_height
    @mouse_location = nil
    @selected_dimension = nil
    super()
  end

  aasm do
    state :init, initial: true
    state :play_button
    state :dimension_selection
    state :image_selection
    state :ended

    event :start_game do
      transitions from: :init, to: :play_button
    end

    event :dimension_selection do
      transitions from: :play_button, to: :dimension_selection
    end

    event :image_selection do
      transitions from: :dimension_selection, to: :image_selection
    end

    event :ended do
      transitions from: [:play_button, :dimension_selection, :image_selection], to: :ended
    end
  end

  def running?
    !aasm.current_state.eql?(:ended)
  end

  def update
    case aasm.current_state
    when :init
      start_game!
    when :play_button
      @current_game_state ||= State::PlayButton.new @game_state
    when :dimension_selection
      @current_game_state ||= State::DimensionSelection.new @game_state
    when :image_selection
      @current_game_state ||= State::ImageSelection.new @game_state, @selected_dimension
    when :ended
    end

    @current_game_state&.update
  end

  # Handle click will be called in the main.rb when there is click events.
  # Each state can have different process.
  def mouse_click click_type # :mouse_down, :mouse_up
    case aasm.current_state
    when :play_button
      # Do something if user click play button
      callback = -> { dimension_selection!;
                      reset_screen;
                    }
      game_state_mouse_click callback: callback
    when :dimension_selection
      @selected_dimension = game_state_mouse_click

      unless @selected_dimension.nil?
        image_selection!
        reset_screen
      end
    when :image_selection
      @current_game_state.mouse_click mouse_location, click_type
    end
  end

  private

  def game_state_mouse_click callback: nil
    return @current_game_state.mouse_click mouse_location if callback.nil?

    @current_game_state.mouse_click mouse_location, callback: callback
  end

  def reset_screen
    Screen.clear
    @current_game_state = nil # Assign nil to change screen properly
  end
end
