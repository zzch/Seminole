class User < ActiveRecord::Base
  include UUID
  as_enum :gender, [:male, :female], prefix: true, map: :string
  has_many :memberships

  def name
    "#{last_name}#{first_name}"
  end

  class << self
    def find_or_create_visitor attributes
      if !attributes.phone.blank? and (exist_user = where(phone: attributes.phone).first)
        exist_user
      else
        create!(attributes.serializable_hash.merge(activated: false))
      end
    end
  end
end