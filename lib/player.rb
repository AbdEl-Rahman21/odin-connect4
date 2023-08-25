# frozen_string_literal: true

require 'rainbow'

class Player
  attr_reader :name
  attr_accessor :number

  def initialize
    @name = ''
    @number = 0
  end

  def get_name
    print "Enter name of Player ##{@number}: "

    @name = gets.chomp
  end

  def get_choice
    loop do
      print "#{@name}, enter your choice: "

      choice = gets.chomp

      return choice.to_i if choice.length == 1 && choice.between?('1', '7')

      puts Rainbow('Error: Your choice must be form 1 to 7.').color(:red)
    end
  end
end
