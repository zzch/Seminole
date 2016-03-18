class AddActionCdToTransactionRecords < ActiveRecord::Migration
  def change
    add_column :transaction_records, :action_cd, :string, limit: 50, null: false, after: :type_cd
  end
end