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
    it 'starts at 0 unless specified' do
      expect(game.home_score).to be 0
      expect(game.away_score).to be 0

      expect(described_class.create(home_score: 10).home_score).to eq 10
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
    it 'starts as :unplayed unless specified' do
      expect(game.status).to be :unplayed

      expect(described_class.create(status_id: 4).status).to eq :shootout
    end

    it 'knows if it has been played' do
      expect(game.played?).to be false

      game.status = :finished

      expect(game.played?).to be true
    end

    it 'has a scope for each status' do
      expect(described_class.unplayed).to include game
    end
  end

  it 'can finish itself' do
    game.finish('4-1')

    expect(game.away_score).to be 4
    expect(game.home_score).to be 1
    expect(game.status).to eq :finished
  end

  it 'can finish itself in OT' do
    game.finish('4-1(OT)')

    expect(game.away_score).to be 4
    expect(game.home_score).to be 1
    expect(game.status).to eq :overtime

    game.finish('2-3(SO)')

    expect(game.away_score).to be 2
    expect(game.home_score).to be 3
    expect(game.status).to eq :shootout
  end

  describe '#show' do
    let(:game) { game = described_class.create(home_team: home_team,
                                               away_team: away_team,
                                               home_score: 1,
                                               away_score: 2,
                                               status_id: Game::STATUS_IDS[:finished]) }

    it 'can be human-readable' do
      expect(game.show).to eq 'away(2) at home(1)'
    end

    it 'shows the status for ot or shootouts' do
      game.status = :overtime

      expect(game.show).to eq 'away(2) at home(1) OT'
    end
  end
end
