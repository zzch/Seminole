class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.references :club, null: false
      t.string :name, limit: 50, null: false
      t.string :value, limit: 100, null: false
      t.timestamps null: false
    end
  end
end