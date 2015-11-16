class AddAbbrevToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :abbrev, :string
  end
end
