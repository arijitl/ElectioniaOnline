class AddColumnWeekNoToWeeklyLeader < ActiveRecord::Migration
  def change
    add_column :weekly_leaders, :week_no, :integer
  end
end
