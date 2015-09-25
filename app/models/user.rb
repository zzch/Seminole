class User < ActiveRecord::Base
  include UUID
  has_many :members
  as_enum :gender, [:male, :female], prefix: true, map: :string

  def name
    "#{last_name}#{first_name}"
  end

  def name_with_initial_and_phone
    "#{PinYin.abbr(name).upcase} / #{last_name}#{first_name} / #{phone}"
  end
end