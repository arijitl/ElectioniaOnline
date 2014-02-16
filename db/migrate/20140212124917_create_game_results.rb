class CreateGameResults < ActiveRecord::Migration
  def change
    create_table :game_results do |t|
      t.integer :user_id
      t.integer :game_id
      t.boolean :votewin
      t.integer :income
      t.integer :expense
      t.integer :contribution
      t.integer :balance

      t.timestamps
    end
  end
end
