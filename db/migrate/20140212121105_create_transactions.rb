class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.date :game_date
      t.string :account
      t.integer :cost
      t.integer :return
      t.integer :balance

      t.timestamps
    end
  end
end
