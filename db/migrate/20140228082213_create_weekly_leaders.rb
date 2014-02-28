class CreateWeeklyLeaders < ActiveRecord::Migration
  def change
    create_table :weekly_leaders do |t|
      t.date :date
      t.integer :user_id
      t.integer :score

      t.timestamps
    end
  end
end
