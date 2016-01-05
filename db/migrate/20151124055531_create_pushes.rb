class CreatePushes < ActiveRecord::Migration
  def change
    create_table :pushes do |t|

      t.timestamps null: false
    end
  end
end
