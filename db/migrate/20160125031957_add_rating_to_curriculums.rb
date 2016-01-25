class AddRatingToCurriculums < ActiveRecord::Migration
  def change
    add_column :curriculums, :rating, :integer, limit: 1, after: :lesson_id
  end
end