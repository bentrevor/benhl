require 'team_standings_presenter'

class StatsController < ApplicationController

  def standings
    season = params[:season].to_i

    @teams = {}

    [:atlantic, :metropolitan, :central, :pacific].each do |division|
      @teams[division] = Team.send(division).map {|t| TeamStandingsPresenter.new(t, season)}
    end

    @season = [season, season + 1]
  end

end
