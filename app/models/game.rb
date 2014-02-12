class Game < ActiveRecord::Base
  belongs_to :firsts, class_name: "Candidate", foreign_key: "first_id"
  belongs_to :seconds, class_name: "Candidate", foreign_key: "second_id"
  belongs_to :thirds, class_name: "Candidate", foreign_key: "third_id"
  belongs_to :winners, class_name: "Candidate", foreign_key: "winner_id"

  has_many :votes, dependent: :destroy
  has_many :anticampaigns, dependent: :destroy

  validates_uniqueness_of :game_date


end
