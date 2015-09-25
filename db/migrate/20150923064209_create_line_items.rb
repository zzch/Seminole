class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :order, null: false
      t.string :type_cd, limit: 20, null: false
      t.references :tee
      t.integer :ball_amount
      t.datetime :started_at
      t.datetime :ended_at
      t.references :product
      t.integer :amount, limit: 1
      t.decimal :price, precision: 7, scale: 2
      t.timestamps null: false
    end
  end
end