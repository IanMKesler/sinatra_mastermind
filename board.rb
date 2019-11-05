class Board
  attr_accessor :board

  def initialize(game)
    @game = game
    @board = []

    create(@game)
  end

  def draw(pattern, turn)
    @board[turn-1] = pattern
  end

  def show
    @board.each { |row| puts row.join }
  end

  private

  def create(game)
    if game == "mastermind"
      12.times { @board << [0, 0, 0, 0] }
      return true
    else
      return false
    end
  end
end
