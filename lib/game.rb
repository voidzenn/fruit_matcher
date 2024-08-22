# frozen_string_literal: true

require "ruby2d"
require "aasm"
require_relative "game_state"
require_relative "custom_classes/button"

class Game
  include AASM

  attr_accessor :mouse_location

  def initialize screen_width, screen_height
    @mouse_location = nil
    @selected_dimension = nil
    super()
  end

  aasm do
    state :init, initial: true
    state :play_button
    state :dimension_selection
    state :show_images
    state :image_selection
    state :game_over

    event :start_game do
      transitions from: :init, to: :play_button
    end

    event :dimension_selection do
      transitions from: :play_button, to: :dimension_selection
    end

    event :show_images do
      transitions from: :dimension_selection, to: :show_images
    end

    event :image_selection do
      transitions from: :show_images, to: :image_selection
    end

    event :game_over do
      transitions from: [:play_button, :dimension_selection, :show_images, :image_selection], to: :game_over
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
    # case aasm.current_state
    # when :init
    #   start_game!
    # when :play_button
    #   game_state.display_sequence :play_button
    # when :dimension_selection
    #   game_state.display_sequence :dimension_selection
    # when :show_images
    #   game_state.display_sequence :show_images
    # when :image_selection
    #   game_state.display_sequence :image_selection
    # when :ended
    # end
  end

  # Handle click will be called in the main.rb when there is click events.
  # Each state can have different process.
  def mouse_click click_type # :mouse_down, :mouse_up
    # case aasm.current_state
    # when :play_button
    #   # Do something if user click play button
    #   callback = -> { dimension_selection!;
    #                   reset_screen;
    #                 }
    #   game_state_mouse_click callback: callback
    # when :dimension_selection
    #   @selected_dimension = game_state_mouse_click

    #   unless @selected_dimension.nil?
    #     image_selection!
    #     reset_screen
    #   end
    # when :image_selection
    #   @current_game_state.mouse_click mouse_location, click_type
    # end
  end

  private

  attr_reader :game_state

  def handle_state
    case aasm.current_state
    when :init
      start_game!
    when :play_button
      PlayButton.new next_event
    when :dimension_selection
      game_state.display_sequence :dimension_selection, next_event
    when :show_images
      game_state.display_sequence :show_images, next_event
    when :image_selection
      game_state.display_sequence :image_selection, next_event
    when :game_over
    end
  end

  def next_event
    -> { transition_event }
  end

  def transition_event
    case aasm.current_state
    when :play_button
      dimension_selection!
    when :dimension_selection
      show_images!
    when :show_images
      image_selection!
    when :image_selection
      game_over!
    when :game_over
    end
  end

  def game_state_mouse_click callback: nil
    return @current_game_state.mouse_click mouse_location if callback.nil?

    @current_game_state.mouse_click mouse_location, callback: callback
  end

  def reset_screen
    Screen.clear
    @current_game_state = nil # Assign nil to change screen properly
  end
end
