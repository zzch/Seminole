class AddPhoneToSalesmen < ActiveRecord::Migration
  def change
    add_column :salesmen, :phone, :string, limit: 20, after: :name
  end
end