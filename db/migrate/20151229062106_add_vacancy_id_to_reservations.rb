class AddVacancyIdToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :vacancy_id, :integer, after: :user_id
  end
end