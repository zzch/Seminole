class Vacancy < ActiveRecord::Base
  include UUID, AASM
  attr_accessor :raw_tags
  belongs_to :club
  belongs_to :tab
  has_many :taggables, class_name: 'VacancyTaggable'
  has_many :tags, through: :taggables
  has_many :provision_items
  as_enum :location, [:first_floor, :second_floor, :third_floor, :green, :simulator], prefix: true, map: :string
  aasm column: 'state' do
    state :opened, initial: true
    state :closed
    state :trashed
    event :close, before: :check_before_close do
      transitions from: :opened, to: :closed
    end
    event :open do
      transitions from: :closed, to: :opened
    end
    event :trash, before: :check_before_trash do
      transitions to: :trashed
    end
  end
  scope :located, ->(location) { where(location_cd: location) }
  validates :name, presence: true, length: { maximum: 10 }, uniqueness: { scope: :club_id }
  validates :location, presence: true
  validates_with VacancyPriceValidator

  def occupied?
    self.tab
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
          create!(club: club, name: name, location_cd: form.location, usual_price_per_hour: form.usual_price_per_hour, holiday_price_per_hour: form.holiday_price_per_hour, usual_price_per_ball: form.usual_price_per_ball, holiday_price_per_ball: form.holiday_price_per_ball).tap do |vacancy|
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
    def check_before_close

    end

    def check_before_trash

    end
end