class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.references :club, null: false
      t.date :date, null: false
      t.string :content, limit: 200
      t.integer :day_code, limit: 2
      t.integer :night_code, limit: 2
      t.integer :maximum_temperature, limit: 2
      t.integer :minimum_temperature, limit: 2
      t.string :probability_of_precipitation, limit: 10
      t.string :wind, limit: 200
      t.timestamps null: false
    end
  end
end