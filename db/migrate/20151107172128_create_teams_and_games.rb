class CreateTeamsAndGames < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :city
      t.string :name
    end

    create_table :games do |t|
      t.integer :home_score
      t.integer :away_score
      t.datetime :datetime
    end

    add_reference :games, :home_team, references: :teams
    add_reference :games, :away_team, references: :teams
  end
end
