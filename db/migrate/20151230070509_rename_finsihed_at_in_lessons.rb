class RenameFinsihedAtInLessons < ActiveRecord::Migration
  def change
    rename_column :lessons, :finsihed_at, :finished_at
  end
end