class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :uuid, limit: 36, null: false
      t.string :name, limit: 100, null: false
      t.string :short_name, limit: 100
      t.string :code, limit: 20, null: false
      t.string :logo, limit: 100
      t.integer :floors, limit: 1, null: false
      t.decimal :longitude, :latitude, precision: 18, scale: 15, null: false
      t.string :address, limit: 800
      t.string :phone_number, limit: 50
      t.timestamps null: false
    end
  end
end
