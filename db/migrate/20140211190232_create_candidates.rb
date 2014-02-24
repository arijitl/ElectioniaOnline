class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.integer :politician_id
      t.integer :game_id
      t.string :comment
      t.integer :vote_count
      t.boolean :winner

      t.timestamps
    end
  end
end
