class RenameLessonsInCourses < ActiveRecord::Migration
  def change
    rename_column :courses, :lessons, :maximum_lessons
  end
end