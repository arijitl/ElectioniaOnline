class Game < ActiveRecord::Base
  has_many :candidates, dependent: :destroy
  has_many :politicians, through: :candidates

  has_many :votes, dependent: :destroy
  has_many :anticampaigns, dependent: :destroy

  validates_uniqueness_of :game_date


end
