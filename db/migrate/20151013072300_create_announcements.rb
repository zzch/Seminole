class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :uuid, limit: 36, null: false
      t.references :club, null: false
      t.string :title, limit: 200, null: false
      t.text :content, null: false
      t.datetime :published_at, null: false
      t.string :state, null: false
      t.timestamps null: false
    end
  end
end