class CreateVacancyTaggables < ActiveRecord::Migration
  def change
    create_table :vacancy_taggables do |t|
      t.references :vacancy, null: false
      t.references :tag, null: false
      t.timestamps null: false
    end
  end
end