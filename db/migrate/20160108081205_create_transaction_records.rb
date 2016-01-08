class CreateTransactionRecords < ActiveRecord::Migration
  def change
    create_table :transaction_records do |t|
    	t.references :member, null: false
      t.references :operator, null: false
      t.string :type_cd, limit: 20, null: false
      t.references :tab
      t.decimal :before_amount, precision: 8, scale: 2, null: false
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.decimal :after_amount, precision: 8, scale: 2, null: false
      t.timestamps null: false
    end
  end
end