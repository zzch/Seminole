class CreateTransactionRecordItems < ActiveRecord::Migration
  def change
    create_table :transaction_record_items do |t|
      t.references :transaction_record, null: false
      t.string :type_cd, limit: 20, null: false
      t.timestamps null: false
    end
  end
end