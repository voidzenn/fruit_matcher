# frozen_string_literal: true

module GameDisplay
  FOUR_BY_FOUR = "4 x 4"
  SIX_BY_SIX = "6 x 6"

  def is_four_by_four? dimension
    dimension.equal? FOUR_BY_FOUR
  end

  def is_six_by_six? dimension
    dimension.equal? SIX_BY_SIX
  end

  def set_timeout seconds, &block
    Thread.new do
      sleep seconds
      block.call
    end
  end
end
