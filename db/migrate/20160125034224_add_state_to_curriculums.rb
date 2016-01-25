class AddStateToCurriculums < ActiveRecord::Migration
  def change
    add_column :curriculums, :state, :string, limit: 20, null: false, after: :rating
  end
end
