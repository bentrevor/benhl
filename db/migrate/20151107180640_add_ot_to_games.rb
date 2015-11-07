class AddOtToGames < ActiveRecord::Migration
  def change
    add_column :games, :status_id, :integer
  end
end
