require 'spec_helper'

describe Team do
  let(:team) { described_class.create(division_id: 1) }
  let(:other_team) { described_class.create(division_id: 2) }

  it 'has a division' do
    expect(team.division).to eq :atlantic
    expect(described_class.atlantic).to include team

    expect(other_team.division).to eq :metropolitan
    expect(described_class.metropolitan).to include other_team
  end

  it 'has many games' do
    expect(team.games).to be_empty

    game = Game.create(home_team: team, away_team: other_team,
                home_score: 0,   away_score: 10, status_id: 2)

    expect(team.games).to eq [game]
  end

  it 'knows how many win/loss/ot it has' do
    Game.create(home_team: team, away_team: other_team,
                home_score: 0,   away_score: 10, status_id: 2)
    Game.create(home_team: team, away_team: other_team,
                home_score: 10,  away_score: 1,  status_id: 2)
    Game.create(home_team: other_team, away_team: team,
                home_score: 2,         away_score: 1,  status_id: 3)

    expect(team.wins).to eq 1
    expect(team.losses).to eq 1
    expect(team.ot_losses).to eq 1

    expect(team.record).to eq '1-1-1'
  end
end
