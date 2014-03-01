class AddColumnYearToWeeklyLeader < ActiveRecord::Migration
  def change
    add_column :weekly_leaders, :year, :string
  end
end
