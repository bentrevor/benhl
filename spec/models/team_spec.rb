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

  describe 'stats' do
    let!(:game1) { Game.create(home_team: team, away_team: other_team,
                               home_score: 0,   away_score: 10, status_id: 2) }
    let!(:game2) { Game.create(home_team: team, away_team: other_team,
                               home_score: 10,  away_score: 1,  status_id: 2) }
    let!(:game3) { Game.create(home_team: other_team, away_team: team,
                               home_score: 2,         away_score: 1,  status_id: 3) }

    it 'knows how many win/loss/ot it has' do
      expect(team.wins).to eq 1
      expect(team.losses).to eq 1
      expect(team.ot_losses).to eq 1

      expect(team.record).to eq '1-1-1'

      expect(other_team.wins).to eq 2
      expect(other_team.losses).to eq 1
      expect(other_team.ot_losses).to eq 0

      expect(other_team.record).to eq '2-1-0'
    end

    it 'knows how many points it has' do
      expect(team.points).to eq 3
      expect(other_team.points).to eq 4
    end

    it 'knows how many goals for/against it has' do
      expect(team.goals_for).to eq 11
      expect(team.goals_against).to eq 13

      expect(other_team.goals_for).to eq 13
      expect(other_team.goals_against).to eq 11
    end

    it 'knows the goal differential' do
      expect(team.goal_diff).to eq -2
      expect(other_team.goal_diff).to eq 2
    end
  end
end
