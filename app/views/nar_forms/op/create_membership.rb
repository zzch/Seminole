class Op::CreateMembership < BaseNarForm
  attr_accessor :phone, :first_name, :last_name, :gender
  validates :phone, presence: true, format: { with: /\A1[0-9]{2} - [0-9]{4} - [0-9]{4}\z/, message: "格式无效" }
  validates :last_name, presence: true, length: { maximum: 25 }
  validates :first_name, presence: true, length: { maximum: 25 }
  validates :gender, presence: true, inclusion: { in: User.genders.keys, message: "格式无效" }

  def attributes
    { phone: nil, last_name: nil, first_name: nil, gender: nil }
  end
end