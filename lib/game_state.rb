# frozen_string_literal: true

FOUR_BY_FOUR = "4 x 4"
SIX_BY_SIX = "6 x 6"

require "ruby2d"
require_relative "custom_classes/screen"
require_relative "custom_classes/button"
require_relative "custom_classes/c_rectangle"
require_relative "asset"

class GameState
  def initialize screen_width, screen_height
    @screen_width = screen_width
    @screen_height = screen_height
  end

  protected

  attr_reader :screen_width, :screen_height

  def draw_button label, x, y, width, height
    Button.new(
      label: label, x: x, y: y, width: width,
      height: height
    )
  end
end

class GameStateInit < GameState
  def initialize game_state
    @game_state = game_state
  end
end

class GameStatePlayButton < GameState
  def initialize game_state
    @game_state = game_state

    show
  end

  def handle_click mouse_location, callback:
    @button&.mouse_location = mouse_location

    if @button&.is_clicked?
      callback.call
    end
  end

  private

  attr_reader :game_state

  def show
    show_play_button
  end

  def center_x width
    (game_state.screen_width - width) / 2
  end

  def center_y height
    (game_state.screen_height - height) / 2
  end

  def show_play_button
    width = 200
    height = 60

    @button = draw_button "Play", center_x(width), center_y(height), width, height
    @button.draw
  end
end

class GameStateDimensionSelection < GameState
  def initialize game_state
    @game_state = game_state

    show
  end

  def handle_click mouse_location
    @btn_1.mouse_location = mouse_location
    @btn_2.mouse_location = mouse_location

    if @btn_1&.is_clicked?
      FOUR_BY_FOUR
    elsif @btn_2&.is_clicked?
      SIX_BY_SIX
    else
      return
    end
  end

  private

  attr_reader :game_state

  def screen_width
    game_state.screen_width
  end

  def show
    draw_selection_button
  end

  def draw_selection_button
    width = 150
    height = 60

    new_y = screen_y_center height

    @btn_1 = draw_button FOUR_BY_FOUR, position_x(1), new_y, width, height
    @btn_1.draw
    @btn_2 = draw_button SIX_BY_SIX, position_x(4), new_y, width, height
    @btn_2.draw
  end

  def position_x column_position
    # Divide width by 6 to have 6 columns
    if column_position <= 6
      column_size = screen_width / 6
      position = column_size * column_position

      return position
    end
  end

  def screen_y_center btn_height
    (game_state.screen_height / 2) - btn_height
  end
end

class GameStateImageSelection < GameState
  def initialize game_state, dimension
    @game_state = game_state
    @dimension = dimension
    @box_positions = []

    show
  end

  def handle_click mouse_location
    @box_positions.each do |button, front_box|
      button.mouse_location = mouse_location

      if button&.is_clicked?
        front_box.hide
      end
    end
  end

  private

  attr_reader :dimension, :assets

  def show
    create_image_boxes
  end

  def create_image_boxes
    if dimension.equal? FOUR_BY_FOUR
      create_four_dimension
    elsif dimension.equal? SIX_BY_SIX
      create_six_dimension
    end
  end

  def create_four_dimension
    create_dimension 100, 8, 4 # 4 x 4
  end

  def create_six_dimension
    create_dimension 80, 18, 6 # 6 x 6
  end

  def create_dimension box_dimension_size, assets_count, dimension
    counter = 0
    # Assets count should be half of the total boxes
    load_assets assets_count
    box_width = 80
    box_height = 80

    dimension.times.each do |row|
      dimension.times.each do |col|
        x = col * box_dimension_size
        y = row * box_dimension_size
        new_box = draw_button nil, x, y, box_width, box_height
        new_box.draw_with_image @assets[counter]
        front_box = CRectangle.new(x: x,
                                   y: y,
                                   width: box_width,
                                   height: box_height,
                                   color: "black")
        front_box.draw

        @box_positions << [new_box, front_box]

        counter += 1
      end
    end
  end

  def load_assets count
    assets = Asset.new(count).random_assets
    new_assets = []
    # We create shuffled duplicates by assets count
    new_assets << assets.shuffle
    new_assets << assets.shuffle
    @assets = new_assets.flatten
  end
end
