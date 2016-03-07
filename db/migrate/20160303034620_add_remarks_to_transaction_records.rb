class AddRemarksToTransactionRecords < ActiveRecord::Migration
  def change
    add_column :transaction_records, :remarks, :string, limit: 500, after: :after_amount
  end
end