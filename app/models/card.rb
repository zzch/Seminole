class Card < ActiveRecord::Base
  include UUID
  attr_accessor :vacancy_tag_ids, :unlimited_total_amount, :unlimited_maximum_vacancies
  belongs_to :club
  has_many :use_rights
  has_many :vacancy_tags, through: :use_rights
  has_many :vacancy_prices, class_name: 'CardVacancyPrice'
  as_enum :type, [:by_ball, :by_time, :unlimited, :stored], prefix: true, map: :string
  validates :name, presence: true, length: { maximum: 50 }
  validates :type, presence: true
  validates :background_color, presence: true, length: { is: 6 }
  validates :font_color, presence: true, length: { is: 6 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :total_amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, unless: "unlimited_total_amount == '1'"
  validates :valid_months, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :maximum_vacancies, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, unless: "unlimited_maximum_vacancies == '1'"

  def reset_use_rights_by_vacancy_tag_ids
    self.use_rights.destroy_all
    self.vacancy_tag_ids.reject(&:blank?).each do |vacancy_tag_id|
      self.club.vacancy_tags.find(vacancy_tag_id).tap do |vacancy_tag|
        self.use_rights.create!(vacancy_tag: vacancy_tag)
      end
    end
  end
end