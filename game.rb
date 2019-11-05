class Game
  require_relative "board.rb"
  require_relative "player.rb"

  def initialize(game)
    @maker = Player.new("maker")
    @breaker = Player.new("breaker")
    @board = Board.new(game)
    @turn = 1
  end

  def play
    puts "Welcome to Mastermind! Input (M) to play as the code maker or (B) to play as the code breaker."
    get_role == "M" ? @maker.player = true : @breaker.player = true
    puts
    puts "Selecting Secret Pattern"
    @maker.player ? @maker.pattern = get_pattern : generate_secret
    while @turn <= 12
      puts
      @board.show
      hints = [0, 0]
      hints = hint if @turn > 1
      puts "Please input guess"
      @breaker.player ? @breaker.pattern = get_pattern : generate_guess(hints)
      @board.draw(@breaker.pattern.dup, @turn)
      if win?
        @board.show
        puts "Nice! The breaker got it!"
        puts "The correct code is #{@maker.show_pattern}"
        return
      else
        @turn += 1
      end
    end
    puts "Better luck next time, breaker. The maker wins!"
    puts "The correct code is #{@maker.show_pattern}"
  end

  private

  def get_role
    input = gets.strip.upcase
    until input.match(/[MB]/)
      puts "Please input either M or B and press enter."
      input = gets.strip.upcase
    end
    input
  end

  def generate_guess(hints)
    correct = hints[0]
    correct_number = hints[1]
    indexes = [0, 1, 2, 3]
    positions = indexes.sample(correct)
    placements = (indexes - positions)
    correct_number_indexes = placements.sample(correct_number)
    keep = {}

    @breaker.pattern = [0, 0, 0, 0] if @breaker.pattern == []
    @breaker.pattern.map!.with_index { |number, index|
      if positions.include?(index)
        puts "Keeping #{number} in position #{index + 1}."
        number
      else
        keep[number] = index if correct_number_indexes.include?(index)
        number = rand(6)
      end
    }

    keep.each { |number, index|
      placement_index = (placements - [index]).sample
      puts "Putting #{number} in position #{placement_index + 1}."
      @breaker.pattern[placement_index] = number
      placements -= [placement_index]
    }
    puts @breaker.show_pattern
  end

  def generate_secret
    4.times { @maker.pattern << rand(6) }
  end

  def get_pattern
    pattern = format_pattern
    until pattern.length == 4
      puts "Please input four numbers from 0-5. Ex: 0254"
      pattern = format_pattern
    end
    pattern
  end

  def format_pattern
    pattern = gets
    output = pattern.scan /[0-5]/
    output.map { |x| x.to_i }
  end

  def win?
    @breaker.pattern == @maker.pattern ? true : false
  end

  def hint
    hints = compare([@maker.pattern, @breaker.pattern])
    puts "#{hints[0]} are correct. #{hints[1]} correct numbers but in the wrong position."
    hints
  end

  def compare(input)
    maker_pattern = input[0].dup #Arrays are not POD types, need to make a shallow copy to avoid changing original.
    breaker_pattern = input[1].dup
    output = [0, 0]
    maker_pattern.each_with_index { |number, index|
      if breaker_pattern[index] == number
        output[0] += 1
        maker_pattern[index] = nil
        breaker_pattern[index] = nil
      end
    }
    maker_pattern = maker_pattern.select { |number| number != nil }
    breaker_pattern = breaker_pattern.select { |number| number != nil }
    maker_pattern.each { |number|
      if breaker_pattern.include?(number)
        output[1] += 1
        breaker_pattern[breaker_pattern.index(number)] = nil
      end
    }
    output
  end
end
