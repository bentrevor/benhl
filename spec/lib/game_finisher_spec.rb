require 'spec_helper'

describe GameFinisher do
  let!(:edm) { Team.create(city: 'Edmonton', abbrev: 'edm') }
  let!(:lak) { Team.create(city: 'Los Angeles', abbrev: 'lak') }

  let(:created_game) { described_class.finish('FINAL: EDM (3) - LAK (4)') }

  it 'creates a game from a string' do
    expect {
      described_class.finish('FINAL: EDM (3) - LAK (4)')
    }.to change {Game.count}.by 1
  end

  it 'sets the teams/scores of the created game' do
    expect(created_game.home_team).to eq lak
    expect(created_game.home_score).to eq 4
    expect(created_game.away_team).to eq edm
    expect(created_game.away_score).to eq 3
  end

  it 'uses today for the datetime' do
    expect(created_game.datetime).to eq Date.today
  end

  it 'uses the 2015 season' do
    # I'll be using a real API by next season
    expect(created_game.season).to eq 2015
  end

  it 'sets the status based on the last word' do
    expect(created_game.status).to eq :finished

    ot_game = described_class.finish('FINAL: EDM (3) - LAK (4) OT')
    so_game = described_class.finish('FINAL: EDM (3) - LAK (4) SO')

    expect(ot_game.status).to eq :overtime
    expect(so_game.status).to eq :shootout
  end
end
