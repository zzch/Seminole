class AddRegistrationIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :registration_id, :string, limit: 128, after: :token
  end
end
