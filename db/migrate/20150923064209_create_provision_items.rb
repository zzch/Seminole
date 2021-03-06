class CreateProvisionItems < ActiveRecord::Migration
  def change
    create_table :provision_items do |t|
      t.references :tab, null: false
      t.references :provision, null: false
      t.integer :quantity, limit: 1, null: false
      t.decimal :price, precision: 7, scale: 2, null: false
      t.string :payment_method_cd, limit: 20
      t.references :member
      t.timestamps null: false
    end
  end
end