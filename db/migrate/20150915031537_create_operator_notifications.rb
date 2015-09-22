class CreateOperatorNotifications < ActiveRecord::Migration
  def change
    create_table :operator_notifications do |t|
      t.references :operator, null: false
      t.string :title, limit: 200, null: false
      t.text :content
      t.boolean :read, default: false, null: false
      t.timestamps null: false
    end
  end
end
