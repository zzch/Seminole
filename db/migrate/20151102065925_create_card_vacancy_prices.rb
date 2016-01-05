class CreateCardVacancyPrices < ActiveRecord::Migration
  def change
    create_table :card_vacancy_prices do |t|
      t.references :card, null: false
      t.references :vacancy, null: false
      t.decimal :usual_price_per_hour, precision: 7, scale: 2
      t.decimal :usual_price_per_bucket, precision: 7, scale: 2
      t.decimal :holiday_price_per_hour, precision: 7, scale: 2
      t.decimal :holiday_price_per_bucket, precision: 7, scale: 2
      t.timestamps null: false
    end
  end
end