class CreateCkeditorAssets < ActiveRecord::Migration
  def change
    create_table :ckeditor_assets do |t|
      t.string :data_file_name, limit: 100, null: false
      t.string :data_content_type, limit: 100
      t.integer :data_file_size
      t.integer :assetable_id
      t.string :assetable_type, limit: 30
      t.string :type, limit: 30
      t.integer :width
      t.integer :height
      t.timestamps null: false
    end
  end
end