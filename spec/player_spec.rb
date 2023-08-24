# frozen_string_literal: true

require_relative '../lib/player'
require 'rainbow'

describe Player do
  describe '#get_choice' do
    subject(:player_choice) { described_class.new }

    context 'when user inputs three invalid inputs, then a valid input' do
      before do
        invalid = ['0', '22', '$']
        valid = '4'
        allow(player_choice).to receive(:print)
        allow(player_choice).to receive(:gets).and_return(invalid[0], invalid[1], invalid[2], valid)
      end

      it 'completes loop and displays error massage three times' do
        message = Rainbow('Error: Your choice must be form 1 to 7.').color(:red)
        expect(player_choice).to receive(:puts).with(message).exactly(3).times
        player_choice.get_choice
      end
    end
  end
end
