class StatsController < ApplicationController

  def standings
    season = params[:season].to_i

    @teams = Team.all.map {|t| TeamPresenter.new(t, season)}
    @season = [season, season + 1]
  end

end
