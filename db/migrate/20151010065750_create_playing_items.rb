class CreatePlayingItems < ActiveRecord::Migration
  def change
    create_table :playing_items do |t|
      t.references :tab, null: false
      t.references :vacancy, null: false
      t.datetime :started_at, null: false
      t.datetime :finished_at
      t.string :charging_type_cd, limit: 20
      t.string :payment_method_cd, limit: 20
      t.references :member
      t.timestamps null: false
    end
  end
end