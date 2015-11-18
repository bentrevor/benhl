require 'team_standings_presenter'

class StatsController < ApplicationController

  def standings
    season = params[:season].to_i
    @last_n = if params[:last_n]
                params[:last_n].to_i
              else
                10
              end

    @titles = {}
    @teams = {}

    scopes.each do |scope|
      @teams[scope] = Team.send(scope).map {|team| TeamStandingsPresenter.new(team, season, params[:start_date], params[:end_date])}
      @titles[scope] = title_for(scope)
    end

    @season = [season, season + 1]
  end

  private

  def scopes
    {
      'by_conference' => [:eastern_conference, :western_conference],
      'whole_league' => [:all],
    }[params[:scope]] || [:atlantic_division, :metropolitan_division, :central_division, :pacific_division]
  end

  def title_for(scope)
    if scope == :all
      'NHL'
    else
      scope.to_s.titleize
    end
  end

end
