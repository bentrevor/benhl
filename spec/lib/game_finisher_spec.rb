require 'spec_helper'

describe GameFinisher do
  let!(:edm) { Team.create(city: 'Edmonton', abbrev: 'edm') }
  let!(:lak) { Team.create(city: 'Los Angeles', abbrev: 'lak') }

  let!(:game) { Game.create(home_team: lak, away_team: edm, datetime: Date.today) }

  let(:finished_game) { described_class.finish('FINAL: EDM (3) - LAK (4)') }

  it 'updates an unfinished game that already exists' do
    expect {
      described_class.finish('FINAL: EDM (3) - LAK (4)')
    }.to change {Game.count}.by 0
  end

  it "finds the game with today's date and the two teams listed" do
    expect(finished_game.id).to eq game.id
  end

  it 'sets the scores of the created game' do
    expect(finished_game.home_score).to eq 4
    expect(finished_game.away_score).to eq 3
  end

  it 'sets the status based on the last word' do
    expect(finished_game.status).to eq :finished

    ot_game = described_class.finish('FINAL: EDM (3) - LAK (4) OT')
    so_game = described_class.finish('FINAL: EDM (3) - LAK (4) SO')

    expect(ot_game.status).to eq :overtime
    expect(so_game.status).to eq :shootout
  end
end
