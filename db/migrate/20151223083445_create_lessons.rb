class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.references :course, null: false
      t.string :name, limit: 100
      t.datetime :started_at, null: false
      t.datetime :finsihed_at, null: false
      t.integer :maximum_students, limit: 2, null: false
      t.timestamps null: false
    end
  end
end