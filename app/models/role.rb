class Role < ActiveRecord::Base

  has_one :users, dependent: :destroy
end
