# frozen_string_literal: true

require_relative './player'
require 'rainbow'

class Game
  def initialize
    @board = Array.new(6) { Array.new(7, 0) }
    @turn_counter = 0
    @players = [Player.new, Player.new]
  end

  def create_players
    @players.each_with_index do |player, i|
      player.number = i + 1
      player.get_name
    end
  end

  def create_board
    system('clear')

    @board.reverse_each do |row|
      row.each do |tile|
        color_tile(tile)
      end

      print "\n"
    end

    puts '1 2 3 4 5 6 7'
  end

  def color_tile(tile)
    case tile
    when 0
      print "\u25cb\s"
    when 1
      print Rainbow("\u25cf\s").color(:red)
    when 2
      print Rainbow("\u25cf\s").color(:yellow)
    end
  end

  def turn_order
    @turn_counter.even? ? play_turn(@players[0]) : play_turn(@players[1])
  end

  def play
    until @turn_counter == 42 # max no. of turns
      turn_order

      break if check_rows || check_columns || check_diagonals

      @turn_counter += 1
    end

    determine_winner
  end

  def play_turn(player)
    create_board

    loop do
      choice = player.get_choice.to_i

      if column_empty?(choice)
        update_column(player, choice)

        break
      else
        puts Rainbow('Column is full').color(:red)
      end
    end
  end

  def column_empty?(choice)
    @board.transpose[choice - 1].include?(0)
  end

  def update_column(player, choice)
    @board.each do |row|
      next unless row[choice - 1].zero?

      row[choice - 1] = player.number

      break
    end
  end

  def check_rows
    @board.each do |row|
      case row
      in [*, 1, 1, 1, 1, *] | [*, 2, 2, 2, 2, *]
        return true
      else
        next
      end
    end

    false
  end

  def check_columns
    @board.transpose.each do |row|
      case row
      in [*, 1, 1, 1, 1, *] | [*, 2, 2, 2, 2, *]
        return true
      else
        next
      end
    end

    false
  end

  def check_diagonals
    get_diagonals.each do |row|
      case row
      in [*, 1, 1, 1, 1, *] | [*, 2, 2, 2, 2, *]
        return true
      else
        next
      end
    end

    false
  end

  def get_diagonals
    padding = [*0..(@board.length - 1)].map { |i| [nil] * i }

    upward_diagonals = padding.reverse.zip(@board).zip(padding).map(&:flatten).transpose.map(&:compact)
    downward_diagonals = padding.zip(@board).reverse.zip(padding).map(&:flatten).transpose.map(&:compact)

    upward_diagonals.union(downward_diagonals).filter { |diagonal| diagonal.size >= 4 }
  end

  def determine_winner
    create_board

    if @turn_counter == 42 # max no. of turns
      puts Rainbow('Draw!').color(:blue)
    elsif @turn_counter.even?
      puts Rainbow("Winner is #{@players[0].name}").color(:green)
    else
      puts Rainbow("Winner is #{@players[1].name}").color(:green)
    end
  end
end