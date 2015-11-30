# nhl.com's schedule has strings of this format:
# FINAL: EDM (3) - LAK (4) OT
class GameFinisher
  class << self
    def finish(game_str, date = Date.yesterday)
      home_team = home_team_from(game_str)
      away_team = away_team_from(game_str)

      raise StandardError, 'bogus home team' unless home_team
      raise StandardError, 'bogus away team' unless away_team

      game = Game.find_by(datetime: date,
                          home_team: home_team,
                          away_team: away_team)

      raise StandardError, "couldn't find a game between those teams on that date" unless game

      if !game.played?
        game.update_attributes(
          home_score: home_score_from(game_str),
          away_score: away_score_from(game_str),
          status_id: status_id_from(game_str),
        )

        game
      end
    end

    def home_team_from(game_str)
      Team[game_str.split[4]]
    end

    def home_score_from(game_str)
      game_str.split[5][1..-2].to_i
    end

    def away_team_from(game_str)
      Team[game_str.split[1]]
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
      when 'S/O'
        Game::STATUS_IDS[:shootout]
      end
    end
  end
end
