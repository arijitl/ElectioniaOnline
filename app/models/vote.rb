class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :candidate
end
