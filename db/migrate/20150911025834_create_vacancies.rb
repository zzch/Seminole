class CreateVacancies < ActiveRecord::Migration
  def change
    create_table :vacancies do |t|
      t.string :uuid, limit: 36, null: false
      t.references :club, null: false
      t.string :name, limit: 20, null: false
      t.integer :floor, limit: 1, null: false
      t.references :tab
      t.datetime :played_at
      t.string :state, limit: 20, null: false
      t.timestamps null: false
    end
  end
end