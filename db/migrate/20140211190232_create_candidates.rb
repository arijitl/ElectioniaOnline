class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :name
      t.boolean :young
      t.boolean :secular
      t.boolean :experienced
      t.boolean :clean
      t.boolean :eminent
      t.boolean :astute
      t.string :comment

      t.timestamps
    end
  end
end
