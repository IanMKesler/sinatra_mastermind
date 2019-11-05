class Player
  attr_accessor :pattern, :player
  attr_reader :role

  def initialize(role)
    @role = role
    @pattern = []
    @player = false
  end

  def show_pattern
    @pattern.join("")
  end
end
