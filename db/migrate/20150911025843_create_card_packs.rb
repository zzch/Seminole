class CreateCardPacks < ActiveRecord::Migration
  def change
    create_table :card_packs do |t|
      t.string :uuid, limit: 36, null: false
      t.references :member, null: false
      t.references :card, null: false
      t.string :number, limit: 50
      t.timestamps null: false
    end
  end
end
