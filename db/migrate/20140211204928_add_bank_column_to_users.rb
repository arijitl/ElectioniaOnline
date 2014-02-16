class AddBankColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bank, :integer
  end
end
