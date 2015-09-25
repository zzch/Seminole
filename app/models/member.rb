class Member < ActiveRecord::Base
  include UUID
  attr_accessor :phone, :first_name, :last_name, :gender
  as_enum :type, [:visitor, :regular], map: :string
  belongs_to :user
  belongs_to :club
  scope :alphabetic, -> { joins(:user).includes(:user).order('CONVERT(users.last_name USING GBK) ASC, CONVERT(users.first_name USING GBK) ASC') }

  def name_with_initial_and_phone
    user.name_with_initial_and_phone
  end

  class << self
    def search options = {}
      where(phone: options[:phone])
    end

    def create_visitor form
      ActiveRecord::Base.transaction do
        user = User.create!(phone: form.phone.gsub(' ', '').gsub('-', ''), first_name: form.first_name, last_name: form.last_name, gender: form.gender, activated: false)
        create!(user: user, type: :visitor)
      end
    end

    def create_regular form
      ActiveRecord::Base.transaction do
        user = User.create!(phone: form.phone.gsub(' ', '').gsub('-', ''), first_name: form.first_name, last_name: form.last_name, gender: form.gender, activated: true)
        create!(user: user, type: :regular)
      end
    end
  end
end