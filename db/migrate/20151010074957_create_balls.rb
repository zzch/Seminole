class CreateBalls < ActiveRecord::Migration
  def change
    create_table :balls do |t|
      t.references :playing_item, null: false
      t.integer :amount, limit: 2, null: false
      t.timestamps null: false
    end
  end
end