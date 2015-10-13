class CreatePlayingItems < ActiveRecord::Migration
  def change
    create_table :playing_items do |t|
      t.references :tab, null: false
      t.references :vacancy, null: false
      t.datetime :started_at, null: false
      t.datetime :finished_at
      t.timestamps null: false
    end
  end
end