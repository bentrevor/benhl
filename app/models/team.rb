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

  def self.[](abbrev)
    find_by(abbrev: abbrev)
  end
end
