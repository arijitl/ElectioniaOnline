class WelcomeController < ApplicationController
  def index
    @game=Game.find_by_game_date(Date.today)
    @candidates=@game.candidates
    @campaigns=Campaign.all.order(:bet)

    @anticampaigns=@candidates.map { |c| [c.id, c.anticampaigns.map{|a| a.campaign.id}] }
    gon.anticampaigns=@anticampaigns

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

    #  Results Details

    @finished_games=Game.all

  end

  def buy_campaign
    @user=current_user
    @game=Game.find_by_game_date(Date.today)
    @campaign=Campaign.find(params[:campaign_id])
    @candidate=Candidate.find(params[:candidate_id])
    @existing=
    if params[:init]=="false"
      @user.bank=@user.bank-@campaign.bet
      @user.save
      @anticampaign=Anticampaign.create!(user_id: @user.id, game_id: @game.id, candidate_id: params[:candidate_id], campaign_id: params[:campaign_id])
    else
      @anticampaign=Anticampaign.where(user_id: @user.id, game_id: @game.id, candidate_id: params[:candidate_id], campaign_id: params[:campaign_id]).first
    end
    render text: "#{@user.bank}||#{@anticampaign.id}"
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
    @candidates=@game.candidates
    @votes_count=@candidates.map{|c| c.votes.count}
    @anticampaign_bets=@candidates.map{|c| c.anticampaigns.map{|a| a.campaign.bet}.sum}
    @antivotes_count=@anticampaign_bets.map{|a| (1-(a.to_f/@anticampaign_bets.sum)) *@votes_count.sum }
    @total_votes=@votes_count.each_with_index.map{|v, index| v+@antivotes_count[index]}
    @winner_id=@candidates[@total_votes.index(@total_votes.max)].id
    @game.winner_id=@winner_id
    @game.save

    @candidates.each_with_index do |candidate,i|
      candidate.vote_count=@total_votes[i]
      candidate.winner=(candidate.id==@winner_id)
      candidate.save
    end

    @users=@game.votes.map { |v| v.user }
    @users.each do |user|
      @game_result=GameResult.new
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
    render text: "#{@game.candidates.map{|c| c.politician.name.to_s + ' got '+ c.vote_count.to_s+' votes' }.join('<br/>')} <br/><br/>#{Candidate.find(@winner_id).politician.name} Won."
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
