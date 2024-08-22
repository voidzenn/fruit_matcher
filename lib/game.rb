# frozen_string_literal: true

require "ruby2d"
require "aasm"
require_relative "states/play_button"
require_relative "states/dimension_selection"
require_relative "states/image_selection"
require_relative "custom_classes/button"

class Game
  include AASM

  attr_accessor :mouse_location

  aasm do
    state :init, initial: true
    state :play_button
    state :dimension_selection
    state :image_selection
    state :game_over

    event :start_game do
      transitions from: :init, to: :play_button
    end

    event :transition_to_dimension_selection do
      transitions from: :play_button, to: :dimension_selection
    end

    event :transition_to_image_selection do
      transitions from: :dimension_selection, to: :image_selection
    end

    event :transition_to_game_over do
      transitions from: [:play_button, :dimension_selection, :image_selection], to: :game_over
    end
  end

  def start
    start_game!
    handle_state
  end

  def running?
    !aasm.current_state.eql?(:ended)
  end

  def update
  end

  def mouse_click click_type
    case click_type
    when :mouse_down
      @current_state.mouse_down mouse_location
    when :mouse_up
      @current_state.mouse_up mouse_location
    end
  end

  private

  attr_reader :game_state

  def handle_state
    case aasm.current_state
    when :init
      start_game!
    when :play_button
      @current_state = PlayButton.new next_event
    when :dimension_selection
      @current_state = DimensionSelection.new next_event
    when :image_selection
      @current_state = ImageSelection.new next_event, @current_state.dimension
    when :game_over
    end
  end

  def next_event
    -> { transition_event; handle_state; }
  end

  def transition_event
    case aasm.current_state
    when :play_button
      transition_to_dimension_selection!
    when :dimension_selection
      transition_to_image_selection!
    when :image_selection
      transition_to_game_over!
    when :game_over
    end
  end
end
