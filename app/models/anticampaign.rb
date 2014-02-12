class Anticampaign < ActiveRecord::Base
  belongs_to :user
  belongs_to :candidate
  belongs_to :campaign
  belongs_to :game
end
