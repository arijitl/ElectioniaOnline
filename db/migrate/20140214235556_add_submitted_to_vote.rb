class AddSubmittedToVote < ActiveRecord::Migration
  def change
    add_column :votes, :submitted, :boolean
  end
end
