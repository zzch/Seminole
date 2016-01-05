class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.references :club, null: false
      t.references :user, null: false
      t.datetime :will_playing_at, null: false
      t.string :state, limit: 20, null: false
      t.timestamps null: false
    end
  end
end