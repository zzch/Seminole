class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.references :category, null: false
      t.string :name, limit: 100, null: false
      t.decimal :price, precision: 7, scale: 2, null: false
      t.text :description
      t.string :state, limit: 20, null: false
      t.timestamps null: false
    end
  end
end
