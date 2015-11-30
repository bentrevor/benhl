class Team < ActiveRecord::Base

  DIVISION_IDS = {
    atlantic: 1,
    metropolitan: 2,
    central: 3,
    pacific: 4,
  }

  DIVISION_IDS.each do |division, id|
    scope "#{division}_division".to_sym, ->{ where(division_id: id) }
  end

  scope :eastern_conference, -> { where(division_id: [DIVISION_IDS[:atlantic], DIVISION_IDS[:metropolitan]]) }
  scope :western_conference, -> { where(division_id: [DIVISION_IDS[:central], DIVISION_IDS[:pacific]]) }

  def division
    DIVISION_IDS.invert[division_id]
  end

  def self.[](abbrev)
    find_by(abbrev: abbrev.downcase)
  end
end
