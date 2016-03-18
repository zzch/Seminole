class AddUuidToTransactionRecords < ActiveRecord::Migration
  def change
    add_column :transaction_records, :uuid, :string, limit: 36, null: false, after: :id
  end
end