class Card < ActiveRecord::Base
  include UUID
  attr_accessor :vacancy_tag_ids, :unlimited_total_amount, :unlimited_maximum_vacancies
  belongs_to :club
  has_many :use_rights
  has_many :vacancy_tags, through: :use_rights
  has_many :vacancy_prices, class_name: 'CardVacancyPrice'
  has_many :members
  before_save :set_total_amount_and_maximum_vacancies
  before_destroy :can_be_destroyed?
  as_enum :type, [:by_ball, :by_time, :unlimited, :stored], prefix: true, map: :string
  validates :name, presence: true, length: { maximum: 50 }
  validates :type, presence: true
  validates :background_color, presence: true, length: { is: 6 }
  validates :font_color, presence: true, length: { is: 6 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, unless: "unlimited_total_amount == '1'"
  validates :valid_months, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :maximum_vacancies, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, unless: "unlimited_maximum_vacancies == '1'"

  def has_right? vacancy
    VacancyTaggable.where(tag_id: self.vacancy_tags.map(&:id)).map{|taggable| taggable.vacancy_id}.uniq.include?(vacancy.id)
  end

  def reset_use_rights_by_vacancy_tag_ids
    self.use_rights.destroy_all
    self.vacancy_tag_ids.reject(&:blank?).each do |vacancy_tag_id|
      self.club.vacancy_tags.find(vacancy_tag_id).tap do |vacancy_tag|
        self.use_rights.create!(vacancy_tag: vacancy_tag)
      end
    end
  end

  def can_be_destroyed?
    raise MemberExists.new unless self.members.blank?
  end

  protected
    def set_total_amount_and_maximum_vacancies
      self.total_amount = 0 if self.unlimited_total_amount == '1'
      self.maximum_vacancies = 0 if self.unlimited_maximum_vacancies == '1'
    end
end