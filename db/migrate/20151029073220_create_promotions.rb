class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :uuid, limit: 36, null: false
      t.references :club, null: false
      t.string :image, limit: 100, null: false
      t.string :title, limit: 200, null: false
      t.text :content
      t.datetime :published_at, null: false
      t.string :state, limit: 20, null: false
      t.timestamps null: false
    end
  end
end