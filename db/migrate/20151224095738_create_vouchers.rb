class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.references :club, null: false
      t.references :tab, null: false
      t.references :user, null: false
      t.string :type_cd, limit: 20, null: false
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.string :state, limit: 20, null: false
      t.datetime :expired_at, null: false
      t.timestamps null: false
    end
  end
end