# frozen_string_literal: true

require "ruby2d"
require_relative "../custom_classes/button"
require_relative "../concerns/game_display"

class ImageSelection
  include GameDisplay

  def initialize next_event, dimension
    @next_event = next_event
    @dimension = dimension
    @box_positions = [] # image_box, front_box, is_show ( default: false )
    @enable_click = true
    @click_count = 0
    create_image_boxes
  end

  def mouse_down mouse_location
    if @enable_click
      @box_positions.each_with_index do |box, index|
        box[:image].mouse_location = mouse_location

        if box[:image]&.is_clicked?
          @click_count += 1
          @current_index = index

          box[:front].hide

          show_hide_box

          break
        end
      end
    end
  end

  def mouse_up mouse_location
    if @enable_click
      @box_positions.each_with_index do |box, index|
        box[:image].mouse_location = mouse_location

        if box[:image]&.is_clicked? && @enable_click
          if !@second_selection.nil?
            @enable_click = false
            set_timeout(0.3) do
              @first_selection[:front].show unless box[:show_image]
              @second_selection[:front].show unless box[:show_image]
              @first_selection = nil
              @second_selection = nil
              @enable_click = true
            end
          end

          break
        end
      end
    end
  end

  private

  attr_reader :next_event, :dimension, :assets

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
    box_width = box_dimension_size
    box_height = box_dimension_size
    margin = 10
    total_width = (dimension * box_dimension_size) + ((dimension - 1) * margin)
    total_height = (dimension * box_dimension_size) + ((dimension - 1) * margin)
    start_x = (Window.width - total_width) / 2
    start_y = (Window.height - total_height) / 2

    dimension.times.each do |row|
      dimension.times.each do |col|
        x = start_x + ( col * (box_dimension_size + margin))
        y = start_y + ( row * (box_dimension_size + margin))
        new_box = Button.new label: nil, x: x, y: y, width: box_width, height: box_height, image_path: @assets[counter]
        new_box.draw_with_image
        front_box = CRectangle.new(x: x,
                                    y: y,
                                    width: box_width,
                                    height: box_height,
                                    color: "black")
        front_box.draw

        @box_positions << {
          image: new_box,
          front: front_box,
          show_image: false
        }

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

  def create_image_boxes
    if is_four_by_four? dimension
      create_four_dimension
    elsif is_six_by_six? dimension
      create_six_dimension
    end

    show_boxes
  end

  def show_boxes
    @enable_click = false
    @box_positions.each{ |bp| bp[:front].hide }

    time_delay = is_six_by_six?(dimension) ? 3 : 2

    set_timeout(time_delay) do
      @box_positions.each{ |bp| bp[:front].show }
      @enable_click = true
    end
  end

  def show_hide_box
    if @first_selection.nil?
      return if @box_positions[@current_index][:show_image] # Skip if image already shown
      @first_selection = @box_positions[@current_index]
    end

    if !@first_selection.nil? && @click_count == 2
      return if @box_positions[@current_index][:show_image] # Skip if image already shown
      @second_selection = @box_positions[@current_index]
      @click_count = 0
      if is_same_selection?
        @first_selection[:show_image] = true
        @second_selection[:show_image] = true
      end
    end
  end

  def is_same_selection?
    return false if @first_selection.nil? || @second_selection.nil?

    @first_selection[:image].image_path == @second_selection[:image].image_path
  end
end