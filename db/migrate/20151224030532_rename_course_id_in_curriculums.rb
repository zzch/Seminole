class RenameCourseIdInCurriculums < ActiveRecord::Migration
  def change
    rename_column :curriculums, :course_id, :lesson_id
  end
end