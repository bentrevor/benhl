class StatsController < ApplicationController

  def standings
    @teams = Team.all
  end

end
