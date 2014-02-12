class CreateAnticampaigns < ActiveRecord::Migration
  def change
    create_table :anticampaigns do |t|
      t.integer :game_id
      t.integer :user_id
      t.integer :candidate_id
      t.integer :campaign_id

      t.timestamps
    end
  end
end
