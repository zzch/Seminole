class CreateTabs < ActiveRecord::Migration
  def change
    create_table :tabs do |t|
      t.string :uuid, limit: 36, null: false
      t.references :club, null: false
      t.references :user, null: false
      t.references :operator, null: false
      t.decimal :price, precision: 7, scale: 2
      t.string :state, limit: 20, null: false
      t.timestamps null: false
    end
  end
end