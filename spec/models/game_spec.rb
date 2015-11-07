require 'spec_helper'

describe Game do
  let(:home_team) { Team.create(name: 'home') }
  let(:away_team) { Team.create(name: 'away') }
  let(:game) { described_class.create(home_team: home_team, away_team: away_team) }

  it 'has a home team and away team' do
    expect(game.home_team).to be home_team
    expect(game.away_team).to be away_team
  end

  describe 'score' do
    it 'starts at 0' do
      expect(game.home_score).to be 0
      expect(game.away_score).to be 0
    end

    it 'knows the winner' do
      game.home_score = 10
      game.away_score = 20

      expect(game.winner).to be away_team

      game.home_score = 30

      expect(game.winner).to be home_team
    end
  end

  describe 'status' do
    it 'starts as :unplayed' do
      expect(game.status).to be :unplayed
    end

    it 'knows if it has been played' do
      expect(game.played?).to be false

      game.status = :finished

      expect(game.played?).to be true
    end
  end
end
