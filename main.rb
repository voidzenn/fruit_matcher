require "ruby2d"
require_relative "lib/screen"
require_relative "lib/custom_rectangle"

SCREEN_WIDTH = 800
SCREE_HEIGHT = 600
BG_COLOR = "white"
TITLE = "Matcher"

Screen.set width: SCREEN_WIDTH, height: SCREE_HEIGHT, title: TITLE, background: BG_COLOR

rect = CustomRectangle.new x: 10, y: 10, width: 100, height: 100, color: "red"

update do
end

render do
  rect.draw
end

Screen.show
