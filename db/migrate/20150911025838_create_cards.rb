class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :uuid, limit: 36, null: false
      t.references :club, null: false
      t.string :type_cd, limit: 20, null: false
      t.string :name, limit: 100
      t.string :background_color, limit: 6
      t.string :font_color, limit: 6
      t.decimal :price, precision: 7, scale: 2
      t.integer :total_amount
      t.integer :valid_months
      t.integer :maximum_vacancies
      t.integer :ball_amount
      t.integer :hour_amount
      t.integer :maximum_daily_balls
      t.integer :maximum_daily_hours
      t.decimal :deposit, precision: 7, scale: 2
      t.decimal :price_per_hour, precision: 7, scale: 2
      t.decimal :price_per_ball, precision: 7, scale: 2
      t.timestamps null: false
    end
  end
end