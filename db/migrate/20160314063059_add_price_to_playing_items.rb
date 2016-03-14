class AddPriceToPlayingItems < ActiveRecord::Migration
  def change
    add_column :playing_items, :price, :decimal, precision: 7, scale: 2, after: :payment_method_cd
  end
end