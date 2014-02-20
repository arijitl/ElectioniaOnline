class AddUserFbAccessTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_Fb_access_token, :string
  end
end
