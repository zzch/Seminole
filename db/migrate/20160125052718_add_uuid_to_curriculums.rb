class AddUuidToCurriculums < ActiveRecord::Migration
  def change
    add_column :curriculums, :uuid, :string, limit: 36, null: false, after: :id
  end
end