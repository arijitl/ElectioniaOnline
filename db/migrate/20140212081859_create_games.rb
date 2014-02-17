class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.date :game_date
      t.integer :winner_id

      t.timestamps
    end
  end
end
