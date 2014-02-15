class WelcomeController < ApplicationController
  def index
    @game=Game.find_by_game_date(Date.today)
    @candidates=[Candidate.find(@game.first_id), Candidate.find(@game.second_id), Candidate.find(@game.third_id)]
    @campaigns=Campaign.all.order(:bet)

    gon.candfirst=@game.first_id
    gon.candsecond=@game.second_id
    gon.candthird=@game.third_id

    gon.antifirst= Anticampaign.where(game_id: @game.id, user_id: current_user.id, candidate_id: @game.first_id).all.map { |c| c.campaign.id }
    gon.antisecond= Anticampaign.where(game_id: @game.id, user_id: current_user.id, candidate_id: @game.second_id).all.map { |c| c.campaign.id }
    gon.antithird= Anticampaign.where(game_id: @game.id, user_id: current_user.id, candidate_id: @game.third_id).all.map { |c| c.campaign.id }

    @vote=Vote.where(game_id: @game.id, user_id: current_user.id).first
    if !@vote.blank?
      gon.candidate=@vote.candidate_id
      if @vote.submitted
        gon.submitted='true'
      else
        gon.submitted='false'
      end
    else
      gon.candidate=-1
      gon.submitted='not a chance'
    end

    @sponsors=Sponsor.all

  end

  def buy_campaign
    @user=current_user
    @game=Game.find_by_game_date(Date.today)
    @campaign=Campaign.find(params[:campaign_id])
    @candidate=Candidate.find(params[:candidate_id])
    @existing=Anticampaign.where(user_id: @user.id, game_id: @game.id)
    if @existing.all.length<6
      if @existing.where(candidate_id: params[:candidate_id], campaign_id: params[:campaign_id]).blank?
        @user.bank=@user.bank-@campaign.bet
        @user.save
        @anticampaign=Anticampaign.create!(user_id: @user.id, game_id: @game.id, candidate_id: params[:candidate_id], campaign_id: params[:campaign_id])
        @msg=@anticampaign.id
      else
        @anticampaign=@existing.where(candidate_id: params[:candidate_id], campaign_id: params[:campaign_id]).first
        @msg=@anticampaign.id
      end
      render text: "#{@user.bank}||#{@msg}"
    else
      render text: "Error"
    end
  end

  def cancel_campaign
    @user=current_user
    @anticampaign=Anticampaign.find(params[:anticampaign_id])
    @refund=@anticampaign.campaign.bet
    @user.bank=@user.bank+@refund
    @user.save
    @anticampaign.destroy
    render text: "#{@user.bank}"
  end

  def cast_vote
    @game=Game.find_by_game_date(Date.today)
    @vote=Vote.where(user_id: current_user.id, game_id: @game.id, candidate_id: params[:candidate_id]).first
    if @vote.blank?
      @vote=Vote.create!(user_id: current_user.id, game_id: @game.id, candidate_id: params[:candidate_id])
    end
    render text: "#{@vote.id}"
  end

  def uncast_vote
    @vote=Vote.find(params[:vote_id])
    @vote.destroy
    render text: "Unvoted"
  end

  def evaluate_game
    @game=Game.find(params[:id])
    @votes=Vote.where(game_id: @game.id).all
    @candidates=@votes.map { |v| v.candidate_id }
    first=@candidates.count(@game.first_id)
    second=@candidates.count(@game.second_id)
    third=@candidates.count(@game.third_id)
    @votecount=@votes.count
    @total_anticampaigns=@game.anticampaigns.all.map { |a| a.campaign.bet }.sum
    first=first+(1-(@game.anticampaigns.where(candidate_id: @game.first_id).all.map { |a| a.campaign.bet }.sum.to_f/@total_anticampaigns.to_f)*@votecount)
    second=second+(1-(@game.anticampaigns.where(candidate_id: @game.second_id).all.map { |a| a.campaign.bet }.sum.to_f/@total_anticampaigns.to_f)*@votecount)
    third=third+(1-(@game.anticampaigns.where(candidate_id: @game.third_id).all.map { |a| a.campaign.bet }.sum.to_f/@total_anticampaigns.to_f)*@votecount)

    winner_id=[@game.first_id, @game.second_id, @game.third_id][[first, second, third].index([first, second, third].max)]
    @game.winner_id=winner_id
    @game.save

    @users=@votes.map { |v| v.user }
    @users.each do |user|

      @game_result=GameResult.new
      # Check the Vote
      @vote=Vote.where(game_id: @game.id, user_id: user.id).first
      if @vote.candidate_id==winner_id
        Transaction.create!(user_id: user.id, game_date: @game.game_date, account: "Vote", cost: 0, return: 2000)
        @game_result.votewin=true
        @gain=2000
      else
        Transaction.create!(user_id: user.id, game_date: @game.game_date, account: "Vote", cost: 0, return: 1000)
        @game_result.votewin=false
        @gain=1000
      end
      # Check the Anticampaigns
      @expense=0
      @anticampaigns=Anticampaign.where(game_id: @game.id, user_id: user.id).all
      @anticampaigns.each do |anticampaign|
        if anticampaign.candidate_id!=winner_id
          Transaction.create!(user_id: user.id, game_date: @game.game_date, account: anticampaign.campaign.name, cost: anticampaign.campaign.bet, return: anticampaign.campaign.payoff)
          @gain=@gain+anticampaign.campaign.payoff
        else
          Transaction.create!(user_id: user.id, game_date: @game.game_date, account: anticampaign.campaign.name, cost: anticampaign.campaign.bet, return: 0)
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
    render text: "#{Candidate.find(@game.first_id).name}: #{first}<br/>#{Candidate.find(@game.second_id).name}: #{second}<br/>#{Candidate.find(@game.third_id).name}: #{third}<br/><br/>Winner: #{Candidate.find(@game.winner_id).name}"
  end

  def finalize
    @game=Game.find_by_game_date(Date.today)
    @vote=Vote.where(game_id: @game.id, user_id: current_user.id).first
    if params[:status]=="true"
      @vote.submitted=true
    else
      @vote.submitted=false
    end
    @vote.save
    render text: "The finalization state is #{@vote.submitted}"

  end

end
