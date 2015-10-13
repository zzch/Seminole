class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :uuid, limit: 36, null: false
      t.references :user, null: false
      t.references :club, null: false
      t.text :content, null: false
      t.boolean :read, default: false, null: false
      t.timestamps null: false
    end
  end
end
