class AddSeasonToGame < ActiveRecord::Migration
  def change
    add_column :games, :season, :integer
  end
end
