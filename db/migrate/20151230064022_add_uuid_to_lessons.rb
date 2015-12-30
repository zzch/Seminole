class AddUuidToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :uuid, :string, limit: 36, null: false, after: :id
  end
end