class WelcomeController < ApplicationController
  def index
    @candidates=Candidate.all.sample(3)
    @campaigns=Campaign.all.order(:bet)
  end
end
