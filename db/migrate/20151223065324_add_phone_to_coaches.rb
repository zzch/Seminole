class AddPhoneToCoaches < ActiveRecord::Migration
  def change
    add_column :coaches, :phone, :string, limit: 20, after: :club_id
  end
end