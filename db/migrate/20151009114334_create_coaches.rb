class CreateCoaches < ActiveRecord::Migration
  def change
    create_table :coaches do |t|
      t.string :uuid, limit: 36, null: false
      t.references :club, null: false
      t.string :name, limit: 50, null: false
      t.string :portrait, limit: 100
      t.string :gender_cd, limit: 10, null: false
      t.string :title, limit: 50, null: false
      t.text :description
      t.boolean :featured, null: false
      t.timestamps null: false
    end
  end
end
