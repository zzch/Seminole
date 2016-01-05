class CreateMemberExpenses < ActiveRecord::Migration
  def change
    create_table :member_expenses do |t|
      t.references :member, null: false
      t.references :item, polymorphic: true
      t.decimal :before_amount, precision: 8, scale: 2, null: false
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.decimal :after_amount, precision: 8, scale: 2, null: false
      t.timestamps null: false
    end
  end
end