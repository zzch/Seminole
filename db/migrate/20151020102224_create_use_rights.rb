class CreateUseRights < ActiveRecord::Migration
  def change
    create_table :use_rights do |t|
      t.references :card, null: false
      t.references :vacancy_tag, null: false
      t.timestamps null: false
    end
  end
end