# frozen_string_literal: true

Warning[:experimental] = false

require_relative './game'

def start
  loop do
    system('clear')

    game = Game.new

    game.create_players

    game.play

    print 'Play again? [Y] for yes any other symbol for no: '

    break unless gets.chomp.downcase == 'y'
  end
end

start
