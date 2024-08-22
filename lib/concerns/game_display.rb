require "ruby2d"

module GameDisplay
  FOUR_BY_FOUR = "4 x 4"
  SIX_BY_SIX = "6 x 6"

  def draw_button label, x, y, width, height, image_path = ""
    Button.new(
      label: label, x: x, y: y, width: width,
      height: height, image_path: image_path
    )
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
    start_x = (game_state.screen_width - total_width) / 2
    start_y = (game_state.screen_height - total_height) / 2

    dimension.times.each do |row|
      dimension.times.each do |col|
        x = start_x + ( col * (box_dimension_size + margin))
        y = start_y + ( row * (box_dimension_size + margin))
        new_box = draw_button(nil, x, y, box_width, box_height, @assets[counter])
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

  def set_timeout seconds, &block
    Thread.new do
      sleep seconds
      block.call
    end
  end
end
