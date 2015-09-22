class CreateCardPacks < ActiveRecord::Migration
  def change
    create_table :card_packs do |t|

      t.timestamps null: false
    end
  end
end
