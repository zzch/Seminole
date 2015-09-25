class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :uuid, limit: 36, null: false
      t.references :club, null: false
      t.references :member, null: false
      t.references :operator, null: false
      t.string :state, limit: 20, null: false
      t.timestamps null: false
    end
  end
end