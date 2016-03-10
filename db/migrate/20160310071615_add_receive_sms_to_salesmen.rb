class AddReceiveSmsToSalesmen < ActiveRecord::Migration
  def change
    add_column :salesmen, :receive_sms, :boolean, null: false, after: :phone
  end
end