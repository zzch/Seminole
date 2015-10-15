class Tab < ActiveRecord::Base
  include UUID, AASM
  belongs_to :club
  belongs_to :user
  belongs_to :operator
  has_many :provision_items
  has_many :playing_items
  has_many :vacancies
  aasm column: 'state' do
    state :progressing, initial: true
    state :cancelled
    state :finished
    event :cancel, before: :before_cancel do
      transitions from: :progressing, to: :cancelled
    end
    event :finish do
      transitions from: :progressing, to: :finished
    end
  end

  def checkout

  end

  def before_cancel
    self.vacancies.each do |vacancy|
      vacancy.update(tab: nil, played_at: nil)
    end
  end

  class << self
    def set_up attributes, vacancy_id
      ActiveRecord::Base.transaction do
        if vacancy_id.blank?
          create!(attributes) if Tab.where(club_id: attributes[:club_id]).where(user_id: attributes[:user_id]).where(state: :progressing).first.blank?
        else
          vacancy = Vacancy.lock.find(vacancy_id)
          raise AlreadyInUse.new if vacancy.occupied?
          (Tab.lock.where(club_id: attributes[:club_id]).where(user_id: attributes[:user_id]).where(state: :progressing).first || create!(attributes)).tap do |tab|
            vacancy.update(tab: tab, played_at: Time.now)
            tab.playing_items.create!(vacancy: vacancy, started_at: Time.now)
          end
        end
      end
    end

    def checkout

    end
  end
end