class AddCoachIdToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :coach_id, :integer, null: false, after: :uuid
  end
end