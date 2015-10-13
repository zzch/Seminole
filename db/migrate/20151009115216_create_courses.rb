class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :uuid, limit: 36, null: false
      t.references :club, null: false
      t.string :name, limit: 100, null: false
      t.integer :valid_months, limit: 1, null: false
      t.integer :maximum_students, limit: 1, null: false
      t.text :description
      t.timestamps null: false
    end
  end
end
