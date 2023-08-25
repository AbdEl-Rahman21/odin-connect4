# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/player'
require 'rainbow'

describe Game do
  describe '#play' do
    subject(:game_loop) { described_class.new }

    context 'when turn_counter equals 42' do
      before do
        max_number_of_turns = 42
        game_loop.instance_variable_set(:@turn_counter, max_number_of_turns)
      end

      it 'calls #determine_winner' do
        expect(game_loop).to receive(:determine_winner)
        game_loop.play
      end
    end

    context 'when #check_rows is false twice' do
      before do
        allow(game_loop).to receive(:check_rows).and_return(false, false, true)
      end

      it 'it calls #turn_order thrice' do
        expect(game_loop).to receive(:turn_order).thrice
        game_loop.play
      end
    end

    context 'when #check_columns is false twice' do
      before do
        allow(game_loop).to receive(:check_rows).and_return(false)
        allow(game_loop).to receive(:check_columns).and_return(false, false, true)
      end

      it 'it calls #turn_order thrice' do
        expect(game_loop).to receive(:turn_order).thrice
        game_loop.play
      end
    end

    context 'when #check_diagonals is false twice' do
      before do
        allow(game_loop).to receive(:check_rows).and_return(false)
        allow(game_loop).to receive(:check_columns).and_return(false)
        allow(game_loop).to receive(:check_diagonals).and_return(false, false, true)
      end

      it 'it calls #turn_order thrice' do
        expect(game_loop).to receive(:turn_order).thrice
        game_loop.play
      end
    end
  end

  describe '#play_turn' do
    subject(:game_turn) { described_class.new }
    let(:player_choice) { instance_double(Player) }

    context 'when player chooses a full column twice' do
      before do
        allow(game_turn).to receive(:create_board)
        allow(game_turn).to receive(:column_empty?).and_return(false, false, true)
        allow(game_turn).to receive(:update_column)
        allow(player_choice).to receive(:get_choice)
      end

      it 'it prints error massage twice' do
        massage = Rainbow('Column is full').color(:red)
        expect(game_turn).to receive(:puts).with(massage).twice
        game_turn.play_turn(player_choice)
      end
    end

    context 'when player chooses an available column' do
      before do
        allow(game_turn).to receive(:create_board)
        allow(game_turn).to receive(:column_empty?).and_return(true)
        allow(player_choice).to receive(:get_choice).and_return('6')
      end

      it 'it calls #update_column' do
        expect(game_turn).to receive(:update_column)
        game_turn.play_turn(player_choice)
      end
    end
  end

  describe '#column_empty?' do
    subject(:game_column) { described_class.new }

    context 'when column is full' do
      before do
        game_column.instance_variable_set(:@board, [[1, 2, 0], [2, 1, 0], [0, 2, 1]])
      end

      it 'returns false' do
        picked_column = 2
        expect(game_column).not_to be_column_empty(picked_column)
      end
    end

    context 'when column is not full' do
      before do
        game_column.instance_variable_set(:@board, [[1, 2, 0], [2, 1, 0], [0, 2, 1]])
      end

      it 'returns true' do
        picked_column = 1
        expect(game_column).to be_column_empty(picked_column)
      end
    end
  end

  describe '#update_column' do
    subject(:game_board) { described_class.new }
    let(:player_number) { double('player', number: 1) }

    it 'replaces empty tile with player tile' do
      picked_column = 2
      board = game_board.instance_variable_get(:@board)
      updated_board = [[0, 1, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0],
                       [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0]]
      expect { game_board.update_column(player_number, picked_column) }.to change { board }.to(updated_board)
    end
  end

  describe '#check_rows' do
    subject(:game_rows) { described_class.new }

    context 'when there are 4 pieces in a row' do
      before do
        game_rows.instance_variable_set(:@board, [[1, 2, 2, 1, 1, 1, 1], [0, 0, 0, 0, 0, 0, 0]])
      end

      it 'returns true' do
        expect(game_rows.check_rows).to be true
      end
    end

    context "when there aren't 4 pieces in a row" do
      it 'returns false' do
        expect(game_rows.check_rows).to be false
      end
    end
  end

  describe '#check_columns' do
    subject(:game_columns) { described_class.new }

    context 'when there are 4 pieces in a column' do
      before do
        game_columns.instance_variable_set(:@board, [[1, 0, 2, 0], [2, 0, 2, 0], [1, 0, 2, 0], [1, 0, 2, 0]])
      end

      it 'returns true' do
        expect(game_columns.check_columns).to be true
      end
    end

    context "when there aren't 4 pieces in a column" do
      it 'returns false' do
        expect(game_columns.check_columns).to be false
      end
    end
  end

  describe '#check_diagonals' do
    subject(:game_diagonals) { described_class.new }

    context 'when there are 4 pieces in a diagonal' do
      before do
        game_diagonals.instance_variable_set(:@board, [[1, 0, 2, 0], [2, 1, 2, 0], [1, 0, 1, 0], [1, 0, 2, 1]])
      end

      it 'returns true' do
        expect(game_diagonals.check_diagonals).to be true
      end
    end

    context "when there aren't 4 pieces in a diagonal" do
      it 'returns false' do
        expect(game_diagonals.check_diagonals).to be false
      end
    end
  end
end
