class Candidate < ActiveRecord::Base
  belongs_to :politician
  belongs_to :game
  has_many :votes, dependent: :destroy
  has_many :anticampaigns, dependent: :destroy

end
