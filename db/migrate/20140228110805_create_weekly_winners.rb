class CreateWeeklyWinners < ActiveRecord::Migration
  def change
    create_table :weekly_winners do |t|
      t.integer :user_id
      t.date :date
      t.integer :week_no
      t.integer :score
      t.string :year

      t.timestamps
    end
  end
end
