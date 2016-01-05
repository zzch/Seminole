class AddTypeCdToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :type_cd, :string, limit: 20, null: false, after: :club_id
  end
end