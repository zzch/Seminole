class CreateProvisionCategories < ActiveRecord::Migration
  def change
    create_table :provision_categories do |t|
      t.references :club, null: false
      t.string :name, limit: 50, null: false
      t.timestamps null: false
    end
  end
end
