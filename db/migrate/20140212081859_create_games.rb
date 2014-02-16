class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.date :game_date
      t.integer :first_id
      t.integer :second_id
      t.integer :third_id
      t.integer :winner_id

      t.timestamps
    end
  end
end
