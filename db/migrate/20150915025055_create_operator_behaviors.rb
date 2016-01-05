class CreateOperatorBehaviors < ActiveRecord::Migration
  def change
    create_table :operator_behaviors do |t|
      t.references :operator, null: false
      t.string :type_cd, limit: 20, null: false
      t.string :content
      t.timestamps null: false
    end
  end
end
