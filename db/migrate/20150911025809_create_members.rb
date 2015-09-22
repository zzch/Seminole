class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :uuid, limit: 36, null: false
      t.references :user, null: false
      t.references :club, null: false
      t.string :type_cd, limit: 20, null: false
      t.timestamps null: false
    end
  end
end