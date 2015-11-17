class TeamStandingsPresenter
  attr_accessor :team, :season, :start_date, :end_date

  def initialize(team, season, start_date=nil, end_date=nil)
    self.team = team
    self.season = season
    self.start_date = start_date
    self.end_date = end_date
  end

  def city
    team.city
  end

  def name
    team.name
  end

  def wins
    @wins ||= home_games.where('home_score > away_score').length +
              away_games.where('home_score < away_score').length
  end

  def losses
    @losses ||= total_losses.where(status_id: Game::STATUS_IDS[:finished]).length
  end

  def ot_losses
    @ot_losses ||= total_losses.where(status_id: [Game::STATUS_IDS[:overtime], Game::STATUS_IDS[:shootout]]).length
  end

  def points
    @points ||= (wins * 2) + ot_losses
  end

  def goals_for
    @goals_for ||= home_games.map(&:home_score).sum + away_games.map(&:away_score).sum
  end

  def goals_against
    @goals_against ||= home_games.map(&:away_score).sum + away_games.map(&:home_score).sum
  end

  def goal_diff
    @goal_diff ||= goals_for - goals_against
  end

  def last_n(n)
    n = 100 if start_date

    @last_n ||= {}
    @last_n[n.to_s] ||= games.where('datetime IS NOT NULL').sort_by(&:datetime).select(&:played?).last(n)
  end

  def show_last_n(n)
    @show_last_n ||= {}
    @show_last_n[n.to_s] ||= last_n(n).map {|g| letter_for(g)}.join
  end

  private

  def letter_for(game)
    if game_is_won?(game)
      'W'
    else
      if game.status_id == 2
        'L'
      else
        'O'
      end
    end
  end

  def home_games
    @home_games ||= games.where(home_team_id: team.id)
  end

  def away_games
    @away_games ||= games.where(away_team_id: team.id)
  end

  def total_losses
    @total_losses ||= games.where("(home_team_id = #{team.id} AND home_score < away_score) OR " +
                                  "(away_team_id = #{team.id} AND home_score > away_score)")
  end

  def games
    if start_date
      query_str = "(home_team_id = #{team.id} OR away_team_id = #{team.id}) AND (datetime >= ? AND datetime <= ?)"
      args = [Date.parse(start_date), Date.parse(end_date)]
    else
      query_str = "home_team_id = #{team.id} OR away_team_id = #{team.id}"
      args = []
    end

    @games ||= Game.where(season: season).where(query_str, *args)
  end

  def game_is_won?(game)
    (game.home_team_id == team.id && game.home_score > game.away_score) ||
      (game.away_team_id == team.id && game.home_score < game.away_score)
  end
end
