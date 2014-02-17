class Campaign < ActiveRecord::Base
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  has_many :anticampaigns, dependent: :destroy

  rails_admin do
    list do
      field :name
      field :bet
      field :payoff
      field :avatar
    end
  end

end
