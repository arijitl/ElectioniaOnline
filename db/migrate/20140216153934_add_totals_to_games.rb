class AddTotalsToGames < ActiveRecord::Migration
  def change
    add_column :games, :first_total, :integer
    add_column :games, :second_total, :integer
    add_column :games, :third_total, :integer
  end
end
