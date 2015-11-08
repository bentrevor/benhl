require 'spec_helper'

describe TeamStandingsPresenter do
  let!(:team_a) { Team.create(division_id: 1) }
  let!(:team_b) { Team.create(division_id: 2) }

  let(:pres12_a) { described_class.new(team_a, 2012) }
  let(:pres12_b) { described_class.new(team_b, 2012) }

  let(:pres14_a) { described_class.new(team_a, 2014) }
  let(:pres14_b) { described_class.new(team_b, 2014) }

  let!(:b_wins_at_a) { Game.create(season: 2012, status_id: 2,
                                   home_team: team_a, home_score: 0,
                                   away_team: team_b, away_score: 10) }
  let!(:b_loses_at_a) { Game.create(season: 2012, status_id: 2,
                                    home_team: team_a, home_score: 10,
                                    away_team: team_b, away_score: 1) }
  let!(:a_loses_at_b_in_OT) { Game.create(season: 2012, status_id: 3,
                                          home_team: team_b, home_score: 2,
                                          away_team: team_a, away_score: 1) }

  let!(:b_loses_at_a_in_OT_in_2014) { Game.create(season: 2014, status_id: 3,
                                                  home_team: team_a, home_score: 10,
                                                  away_team: team_b, away_score: 1) }
  let!(:a_loses_at_b_in_2014) { Game.create(season: 2014, status_id: 2,
                                            home_team: team_b, home_score: 2,
                                            away_team: team_a, away_score: 1) }

  it 'knows how many win/loss/ot it has' do
    expect(pres12_a.wins).to eq 1
    expect(pres12_a.losses).to eq 1
    expect(pres12_a.ot_losses).to eq 1

    expect(pres12_b.wins).to eq 2
    expect(pres12_b.losses).to eq 1
    expect(pres12_b.ot_losses).to eq 0
  end

  it 'knows how many points it has' do
    expect(pres12_a.points).to eq 3
    expect(pres12_b.points).to eq 4
  end

  it 'knows how many goals for/against it has' do
    expect(pres12_a.goals_for).to eq 11
    expect(pres12_a.goals_against).to eq 13

    expect(pres12_b.goals_for).to eq 13
    expect(pres12_b.goals_against).to eq 11
  end

  it 'knows the goal differential' do
    expect(pres12_a.goal_diff).to eq -2
    expect(pres12_b.goal_diff).to eq 2
  end
end
