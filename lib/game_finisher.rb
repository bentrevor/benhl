# nhl.com's schedule has strings of this format:
# FINAL: EDM (3) - LAK (4) OT
class GameFinisher
  class << self
    def finish(game_str)
      Game.create(
        home_team: home_team_from(game_str),
        away_team: away_team_from(game_str),
        home_score: home_score_from(game_str),
        away_score: away_score_from(game_str),
        status_id: status_id_from(game_str),
        season: 2015,
        datetime: Date.today,
      )
    end

    def home_team_from(game_str)
      Team[game_str.split[4].downcase]
    end

    def home_score_from(game_str)
      game_str.split[5][1..-2].to_i
    end

    def away_team_from(game_str)
      Team[game_str.split[1].downcase]
    end

    def away_score_from(game_str)
      game_str.split[2][1..-2].to_i
    end

    def status_id_from(game_str)
      if game_str.split.length == 6
        Game::STATUS_IDS[:finished]
      else
        if game_str.split.last == 'OT'
          Game::STATUS_IDS[:overtime]
        else
          Game::STATUS_IDS[:shootout]
        end
      end
    end
  end
end
