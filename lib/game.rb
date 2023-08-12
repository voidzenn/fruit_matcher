RUNNING = :running
ENDED = :ended

class Game
  def initialize
    @game_state = RUNNING
  end

  def running?
    @game_state == RUNNING
  end

  def stop
    stop_game
  end

  private

  attr_accessor :game_state

  def stop_game
    game_state = ENDED
  end
end
