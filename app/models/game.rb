class Game < ActiveRecord::Base
  has_many :candidates, dependent: :destroy
  has_many :politicians, through: :candidates

  has_many :votes, dependent: :destroy
  has_many :anticampaigns, dependent: :destroy

  validates_uniqueness_of :game_date



  def self.game_evaluate
    @game=Game.find_by_game_date(Date.today)
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
  end

  def self.show_for_current_week
    where(':first_day <= game_date AND game_date <= :last_day',{:first_day=>Date.today.at_beginning_of_week,:last_day=>Date.today.at_end_of_week})
  end


end
