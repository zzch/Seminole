class CreateProvisions < ActiveRecord::Migration
  def change
    create_table :provisions do |t|
      t.string :uuid, limit: 36, null: false
      t.references :category, null: false
      t.string :serial_number, limit: 50
      t.string :name, limit: 100, null: false
      t.string :image, limit: 100
      t.decimal :price, precision: 7, scale: 2, null: false
      t.string :image, limit: 100
      t.text :description
      t.string :state, limit: 20, null: false
      t.timestamps null: false
    end
  end
end
