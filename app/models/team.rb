class Team < ActiveRecord::Base

  DIVISION_IDS = {
    atlantic: 1,
    metropolitan: 2,
    central: 3,
    pacific: 4,
  }

  DIVISION_IDS.each do |division, id|
    scope division, ->{ where(division_id: id) }
  end

  def division
    DIVISION_IDS.invert[division_id]
  end

  def games
    @games ||= Game.where('home_team_id = ? OR away_team_id = ?', id, id)
  end

  def wins
    @wins ||= home_games.where('home_score > away_score').length +
              away_games.where('home_score < away_score').length
  end

  def losses
    @losses ||= total_losses.where(status_id: Game::STATUS_IDS[:finished]).length
  end

  def ot_losses
    @losses ||= total_losses.where(status_id: [Game::STATUS_IDS[:overtime], Game::STATUS_IDS[:shootout]]).length
  end

  def record
    "#{wins}-#{losses}-#{ot_losses}"
  end

  private

  def home_games
    @home_games ||= games.where(home_team_id: id)
  end

  def away_games
    @away_games ||= games.where(away_team_id: id)
  end

  def total_losses
    @total_losses ||= games.where("(home_team_id = #{id} AND home_score < away_score) OR " +
                                  "(away_team_id = #{id} AND home_score > away_score)")
  end
end
