require 'team_standings_presenter'

class StatsController < ApplicationController

  def standings
    season = params[:season].to_i
    @last_n = if params[:last_n]
                params[:last_n].to_i
              else
                10
              end

    @teams = {}

    [:atlantic, :metropolitan, :central, :pacific].each do |division|
      @teams[division] = Team.send(division).map {|team| TeamStandingsPresenter.new(team, season, params[:start_date], params[:end_date])}
    end

    @season = [season, season + 1]
  end

end
