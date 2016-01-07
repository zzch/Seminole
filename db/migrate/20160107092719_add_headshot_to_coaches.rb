class AddHeadshotToCoaches < ActiveRecord::Migration
  def change
    add_column :coaches, :headshot, :string, limit: 100, after: :name
  end
end