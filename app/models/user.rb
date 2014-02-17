require 'open-uri'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  #validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :votes, dependent: :destroy
  has_many :anticampaigns, dependent: :destroy

  before_create :give_money

  def give_money
    self.bank=1000
  end

  def self.find_for_facebook_oauth(provider, uid, name, email, picture, signed_in_resource=nil)
    user = User.where(:provider => provider, :uid => uid).first
    unless user
      user = User.create(:name => name,
                         :provider => provider,
                         :uid => uid,
                         :email => email,
                         :password => Devise.friendly_token[0,20],
                         :avatar=> open(picture)
      )

    end
    return user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end
