# frozen_string_literal: true

require "ruby2d"

class CImage
  def initialize path:, x:, y:, width:, height:, options: {}
    @path = path
    @x = x
    @y = y
    @width = width
    @height = height
    @options = options
  end

  def draw
    Image.new path, x: x, y: y, width: width, height: height
  end

  private

  attr_reader :path, :x, :y, :width, :height, :options
end