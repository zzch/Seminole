class RenameCoachIdInCurriculums < ActiveRecord::Migration
  def change
    rename_column :curriculums, :coach_id, :user_id
  end
end