class AddShortDescriptionToCoaches < ActiveRecord::Migration
  def change
    add_column :coaches, :short_description, :text, after: :starting_price
  end
end