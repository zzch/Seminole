class CreateCurriculums < ActiveRecord::Migration
  def change
    create_table :curriculums do |t|
      t.references :coach, null: false
      t.references :course, null: false
      t.timestamps null: false
    end
  end
end