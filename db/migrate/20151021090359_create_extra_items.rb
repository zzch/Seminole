class CreateExtraItems < ActiveRecord::Migration
  def change
    create_table :extra_items do |t|
      t.references :tab, null: false
      t.string :type_cd, limit: 20, null: false
      t.decimal :price, precision: 7, scale: 2, null: false
      t.text :remarks
      t.string :payment_method_cd, limit: 20
      t.references :member
      t.timestamps null: false
    end
  end
end