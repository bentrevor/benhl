# nhl.com's schedule has strings of this format:
# FINAL: EDM (3) - LAK (4) OT
class GameFinisher
  class << self
    def finish(game_str)
      game = Game.find_by(datetime: Date.today,
                          home_team: home_team_from(game_str),
                          away_team: away_team_from(game_str))

      game.update_attributes(
        home_score: home_score_from(game_str),
        away_score: away_score_from(game_str),
        status_id: status_id_from(game_str),
      )

      game
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
      case game_str.split[6]
      when nil
        Game::STATUS_IDS[:finished]
      when 'OT'
        Game::STATUS_IDS[:overtime]
      when 'SO'
        Game::STATUS_IDS[:shootout]
      end
    end
  end
end
