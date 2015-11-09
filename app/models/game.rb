class Game < ActiveRecord::Base
  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'

  before_create :set_scores_and_status

  STATUS_IDS = {
    unplayed: 1,
    finished: 2,
    overtime: 3,
    shootout: 4,
  }

  STATUS_IDS.each do |status, id|
    scope status, ->{ where(status_id: id) }
  end

  def winner
    if home_score > away_score
      home_team
    elsif home_score < away_score
      away_team
    end
  end

  def status
    STATUS_IDS.invert[status_id]
  end

  def status=(status_name)
    self.status_id = STATUS_IDS[status_name]
  end

  def played?
    status_id > 1
  end

  def finish(score)
    new_away_score = score.split('-')[0].to_i
    new_home_score = score.split('-')[1].to_i
    new_status_id = if score.index 'SO'
                      4
                    elsif score.index 'OT'
                      3
                    else
                      2
                    end

    update_attributes({ home_score: new_home_score,
                        away_score: new_away_score,
                        status_id: new_status_id })
  end

  private

  def set_scores_and_status
    self.home_score ||= 0
    self.away_score ||= 0
    self.status_id  ||= 1
  end
end
