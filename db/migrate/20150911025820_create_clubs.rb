class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :uuid, limit: 36, null: false
      t.string :name, limit: 100, null: false
      t.string :code, limit: 20, null: false
      t.integer :floors, limit: 1, null: false
      t.decimal :longitude, :latitude, precision: 18, scale: 15
      t.string :address, limit: 800
      t.timestamps null: false
    end
  end
end
