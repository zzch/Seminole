class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :uuid, limit: 36, null: false
      t.references :club, null: false
      t.string :type_cd, limit: 20, null: false
      t.string :name, limit: 100, null: false
      t.decimal :price, precision: 7, scale: 2, null: false
      t.integer :total_amount, null: false
      t.integer :valid_months, null: false
      t.integer :maximum_tees, null: false
      t.integer :ball_amount
      t.integer :minute_amount
      t.integer :minimum_charging_minutes
      t.integer :unit_charging_minutes
      t.integer :maximum_discard_minutes
      t.integer :maximum_daily_balls
      t.integer :maximum_daily_hours
      t.timestamps null: false
    end
  end
end