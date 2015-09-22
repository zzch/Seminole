class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.integer :major, :minor, :point, limit: 2, null: false
      t.string :build, null: false
      t.text :content
      t.string :state, limit: 20, null: false
      t.timestamps null: false
    end
  end
end
