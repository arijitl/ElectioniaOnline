require 'open-uri'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :votes, dependent: :destroy
  has_many :anticampaigns, dependent: :destroy
  belongs_to :role

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
      if !session["devise.facebook_data"]["extra"].nil?
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      else
        user.email = "random_user@electionia.com" if user.email.blank?
      end

    end
  end


  def evaluate_gaming
    @game=Game.find(params[:id])
    @candidates=@game.candidates
    @votes_count=@candidates.map { |c| c.votes.count }
    @anticampaign_bets=@candidates.map { |c| c.anticampaigns.map { |a| a.campaign.bet }.sum }
    @antivotes_count=@anticampaign_bets.map { |a| (1-(a.to_f/@anticampaign_bets.sum)) *@votes_count.sum }
    @total_votes=@votes_count.each_with_index.map { |v, index| v+@antivotes_count[index] }
    @winner_id=@candidates[@total_votes.index(@total_votes.max)].id
    @game.winner_id=@winner_id
    @game.save

    @candidates.each_with_index do |candidate, i|
      candidate.vote_count=@total_votes[i]
      candidate.winner=(candidate.id==@winner_id)
      candidate.save
    end

    @users=@game.votes.map { |v| v.user }
    @users.each do |user|
      @game_result=GameResult.new
      @game_result.game_id =@game.id
      @game_result.user_id =user.id
      # Check the Vote
      @vote=Vote.where(game_id: @game.id, user_id: user.id).first
      if @vote.candidate_id==@winner_id
        @game_result.votewin=true
        @gain=2000
      else
        @game_result.votewin=false
        @gain=1000
      end
      # Check the Anticampaigns
      @expense=0
      @anticampaigns=Anticampaign.where(game_id: @game.id, user_id: user.id).all
      @anticampaigns.each do |anticampaign|
        if anticampaign.candidate_id!=@winner_id
          @gain=@gain+anticampaign.campaign.payoff
        end
        @expense=@expense+anticampaign.campaign.bet
      end
      user.bank=user.bank+@gain
      user.save
      @game_result.income = @gain
      @game_result.expense = @expense
      @game_result.contribution = @gain-@expense
      @game_result.balance=user.bank
      @game_result.save
    end
    render text: "#{@game.candidates.map { |c| c.politician.name.to_s + ' got '+ c.vote_count.to_s+' votes' }.join('<br/>')} <br/><br/>#{Candidate.find(@winner_id).politician.name} Won."
  end
end
