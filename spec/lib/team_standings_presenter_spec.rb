require 'spec_helper'

describe TeamStandingsPresenter do
  let!(:team_a) { Team.create(division_id: 1, name: 'a', city: 'atown') }
  let!(:team_b) { Team.create(division_id: 2, name: 'b', city: 'btown') }

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

  it 'delegates name and city to the team' do
    expect(pres12_a.name).to eq team_a.name
    expect(pres12_a.city).to eq team_a.city
  end

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

  describe 'last 10' do
    let!(:early_game) { Game.create(season: 2012, datetime: Date.parse("Oct 1, 2014"), status_id: 2,
                                    home_team: team_b, home_score: 2,
                                    away_team: team_a, away_score: 1) }

    let!(:ot_win) { Game.create(season: 2012, datetime: Date.parse("Oct 27, 2014"), status_id: 3,
                                 home_team: team_b, home_score: 1,
                                 away_team: team_a, away_score: 2) }

    let!(:ot_loss) { Game.create(season: 2012, datetime: Date.parse("Oct 28, 2014"), status_id: 3,
                                 home_team: team_b, home_score: 2,
                                 away_team: team_a, away_score: 1) }

    let!(:so_win) { Game.create(season: 2012, datetime: Date.parse("Oct 29, 2014"), status_id: 4,
                                 home_team: team_b, home_score: 1,
                                 away_team: team_a, away_score: 2) }

    let!(:so_loss) { Game.create(season: 2012, datetime: Date.parse("Oct 30, 2014"), status_id: 4,
                                home_team: team_b, home_score: 2,
                                away_team: team_a, away_score: 1) }

    let!(:last_game) { Game.create(season: 2012, datetime: Date.parse("Oct 31, 2014"), status_id: 2,
                                   home_team: team_b, home_score: 1,
                                   away_team: team_a, away_score: 10) }

    let!(:not_played_yet) { Game.create(season: 2012, datetime: Date.parse("Nov 10, 2014"), status_id: 1,
                                        home_team: team_b, away_team: team_a) }

    before do
      10.times do |i|
        Game.create(season: 2012, datetime: Date.parse("Oct #{i + 2}, 2014"), status_id: 2,
                    home_team: team_b, home_score: 2,
                    away_team: team_a, away_score: 1)
      end
    end

    it 'knows the last 10 games' do
      expect(pres12_a.last_n(10).length).to eq 10
      expect(pres12_a.last_n(10)).not_to include early_game
      expect(pres12_a.last_n(10)).not_to include not_played_yet
      expect(pres12_a.last_n(10).last).to eq last_game
    end

    it 'shows the last 10 games' do
      expect(pres12_a.show_last_n(10).length).to eq 10
      expect(pres12_a.show_last_n(10)).to eq 'LLLLLWOWOW'
    end
  end
end
