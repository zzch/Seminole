class RemoveClubIdFromCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :club_id
  end
end