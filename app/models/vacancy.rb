class Vacancy < ActiveRecord::Base
  include UUID, AASM
  attr_accessor :raw_tags
  as_enum :location, [:first_floor, :second_floor, :third_floor, :green, :simulator], prefix: true, map: :string
  belongs_to :club
  belongs_to :tab
  has_many :taggables, class_name: 'VacancyTaggable'
  has_many :tags, through: :taggables
  has_many :provision_items
  aasm column: 'state' do
    state :opened, initial: true
    state :closed
    state :trashed
    event :close do
      transitions from: :opened, to: :closed
    end
    event :open do
      transitions from: :closed, to: :opened
    end
    event :trash do
      transitions to: :trashed
    end
  end
  before_save :set_price
  scope :located, ->(location) { where(location_cd: location) }
  validates :name, presence: true, length: { maximum: 10 }, uniqueness: { scope: [:club_id, :location_cd] }
  validates :location, presence: true
  validates_with VacancyPriceValidator

  def occupied?
    self.tab
  end

  def pay_by_ball?
    !self.usual_price_per_bucket.blank? and !self.holiday_price_per_bucket.blank?
  end

  def pay_by_time?
    !self.usual_price_per_hour.blank? and !self.holiday_price_per_hour.blank?
  end

  def reset_tags_by_raw_string
    self.taggables.destroy_all
    self.raw_tags.split(',').each do |tag|
      VacancyTag.find_or_create_by(club_id: club.id, name: tag).tap do |tag|
        self.taggables.create!(tag: tag)
      end
    end
  end

  class << self
    def bulk_create club, form
      ActiveRecord::Base.transaction do
        tags = form.tags.split(',').map do |tag|
          VacancyTag.find_or_create_by(club_id: club.id, name: tag)
        end
        (form.start_number.to_i..form.end_number.to_i).each do |number|
          name = "#{form.prefix}#{number}#{form.suffix}"
          raise DuplicatedVacancy.new if where(club: club, name: name).first
          create!(club: club, name: name, location_cd: form.location, usual_price_per_hour: form.usual_price_per_hour, holiday_price_per_hour: form.holiday_price_per_hour, usual_price_per_bucket: form.usual_price_per_bucket, holiday_price_per_bucket: form.holiday_price_per_bucket).tap do |vacancy|
            vacancy.taggables.destroy_all
            tags.each do |tag|
              self.taggables.create!(tag: tag)
            end
          end
        end
      end
    end
  end

  protected
    def set_price
      %w(bucket hour).each do |type|
        %w(usual holiday).tap do |dates|
          (0..1).each do |i|
            self.send("#{dates[i - 1]}_price_per_#{type}=", self.send("#{dates[i]}_price_per_#{type}")) if !self.send("#{dates[i]}_price_per_#{type}").blank? and self.send("#{dates[i - 1]}_price_per_#{type}").blank?
          end
        end
      end
    end
end