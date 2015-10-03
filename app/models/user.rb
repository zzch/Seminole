class User < ActiveRecord::Base
  include UUID
  as_enum :gender, [:male, :female], prefix: true, map: :string
  has_many :memberships

  def name
    "#{last_name}#{first_name}"
  end
end