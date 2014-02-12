class Candidate < ActiveRecord::Base
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  has_many :firsts, class_name: "Game", foreign_key: "first_id"
  has_many :seconds, class_name: "Game", foreign_key: "second_id"
  has_many :thirds, class_name: "Game", foreign_key: "third_id"
  has_many :winners, class_name: "Game", foreign_key: "winner_id"
  has_many :votes, dependent: :destroy
  has_many :anticampaigns, dependent: :destroy

end
