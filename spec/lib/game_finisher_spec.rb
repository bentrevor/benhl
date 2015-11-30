require 'spec_helper'

describe GameFinisher do
  let!(:edm) { Team.create(city: 'Edmonton', abbrev: 'edm') }
  let!(:lak) { Team.create(city: 'Los Angeles', abbrev: 'lak') }

  let!(:game) { Game.create(home_team: lak, away_team: edm, datetime: Date.yesterday) }

  let(:finished_game) { described_class.finish('FINAL: EDM (3) - LAK (4)') }

  it 'updates an unfinished game that already exists' do
    expect {
      described_class.finish('FINAL: EDM (3) - LAK (4)')
    }.to change {Game.count}.by 0
  end

  describe 'date' do
    it "finds the game with yesterday's date by default" do
      expect(finished_game.id).to eq game.id
    end

    it "can be passed a specific date" do
      old_game = Game.create(home_team: lak, away_team: edm, datetime: Date.yesterday - 10.days)
      described_class.finish('FINAL: EDM (3) - LAK (4)', Date.yesterday - 10.days)

      expect(game.reload.status).to eq :unplayed
      expect(old_game.reload.status).to eq :finished
    end
  end

  it 'sets the scores of the created game' do
    expect(finished_game.home_score).to eq 4
    expect(finished_game.away_score).to eq 3
  end

  describe 'setting the status' do
    context 'for overtime game' do
      it 'uses "OT"' do
        ot_game = described_class.finish('FINAL: EDM (3) - LAK (4) OT')

        expect(ot_game.status).to eq :overtime
      end
    end

    context 'for shootout' do
      it 'sets the status based on the last word' do
        so_game = described_class.finish('FINAL: EDM (3) - LAK (4) S/O')

        expect(so_game.status).to eq :shootout
      end
    end
  end

  it 'only updates an unplayed game' do
    described_class.finish('FINAL: EDM (3) - LAK (4)')
    described_class.finish('FINAL: EDM (100) - LAK (200)')

    game.reload

    expect(game.away_score).to eq 3
    expect(game.home_score).to eq 4
  end

  it 'raises an error for unfound games/teams' do
    expect { described_class.finish 'FINAL: LAK (0) - bogus (0)' }.to raise_error StandardError, 'bogus home team'
    expect { described_class.finish 'FINAL: bogus (0) - LAK (0)' }.to raise_error StandardError, 'bogus away team'
    expect {
      described_class.finish('FINAL: EDM (3) - LAK (4)', game.datetime - 10.days)
    }.to raise_error StandardError, "couldn't find a game between those teams on that date"
  end
end
