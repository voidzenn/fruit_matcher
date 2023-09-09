# frozen_string_literal: true

ASSET_PATH_LIST = Dir.glob "lib/assets/*.{png,jpg,jpeg}"

class Asset
  def initialize count
    @count = count
    @asset_path_list = ASSET_PATH_LIST
  end

  def random_assets
    distinct_random_assets
  end

  private

  attr_reader :asset_path_list, :count

  def distinct_random_assets
    assets = asset_path_list.shuffle
    # Subtract 1 to make asset count accurate
    assets[0..count-1]
  end
end