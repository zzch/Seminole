class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :uuid, limit: 36, null: false
      t.references :card, null: false
      t.references :club, null: false
      t.string :number, limit: 100
      t.integer :ball_amount, null: false
      t.integer :minute_amount, null: false
      t.decimal :balance, precision: 7, scale: 2, null: false
      t.datetime :expired_at, null: false
      t.string :state, limit: 20, null: false
      t.timestamps null: false
    end
  end
end