class Member < ActiveRecord::Base
  include UUID
  attr_accessor :phone, :first_name, :last_name, :gender
  as_enum :type, [:visitor, :regular], map: :string
  belongs_to :user
  belongs_to :club

  class << self
    def search options = {}
      where(phone: options[:phone])
    end

    def create_visitor form
      ActiveRecord::Base.transaction do
        raise DuplicatedPhone.new if !form.phone.blank? and User.where(phone: form.phone).first
        user = User.create!(phone: form.phone, first_name: form.first_name, last_name: form.last_name, gender: form.gender, activated: false)
        create!(user: user, type: :visitor)
      end
    end

    def create_regular form
      ActiveRecord::Base.transaction do
        raise DuplicatedPhone.new if User.where(phone: form.phone).first
        user = User.create!(phone: form.phone, first_name: form.first_name, last_name: form.last_name, gender: form.gender, activated: true)
        create!(user: user, type: :regular)
      end
    end
  end
end