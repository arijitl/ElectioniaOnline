class AddDescriptionToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :description, :string
  end
end
