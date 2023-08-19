require "ruby2d"
require_relative "custom_classes/screen"
require_relative "custom_classes/button"

class GameState
  def initialize screen_width, screen_height
    @screen_width = screen_width
    @screen_height = screen_height
  end

  def init
    instance ||= GameStateInit.new self
  end

  def play_button
    instance ||= GameStatePlayButton.new self
  end

  def dimension_selection
    instance ||= GameStateDimensionSelection.new self
  end

  protected

  attr_reader :screen_width, :screen_height
end

class GameStateInit < GameState
  def initialize game_state
    @game_state = game_state
  end
end

class GameStatePlayButton < GameState
  def initialize game_state
    @game_state = game_state

    show_play_button
  end

  def handle_click mouse_location, callback:
    @button&.mouse_location = mouse_location

    if @button&.is_clicked?
      callback.call
    end
  end

  private

  attr_reader :game_state

  def show_play_button
    play_button ||= create_play_button
  end

  def center_x width
    (game_state.screen_width / 2) - (width / 2)
  end

  def center_y height
    (game_state.screen_height / 2) - (height / 2)
  end

  def create_play_button
    width = 200
    height = 60

    @button = Button.new(
      label: "Play", x: center_x(width), y: center_y(height), width: width,
      height: height
    )
    @button.draw
  end
end

class GameStateDimensionSelection < GameState
  def initialize game_state
    @game_state = game_state

    show_selection
  end

  private

  attr_reader :game_state

  def show_selection
  end
end
