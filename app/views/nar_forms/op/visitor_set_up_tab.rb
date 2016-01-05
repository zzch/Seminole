class Op::VisitorSetUpTab < BaseNarForm
  attr_accessor :phone, :first_name, :last_name, :gender
  validates :phone, format: { with: /\A1[0-9]{2} - [0-9]{4} - [0-9]{4}\z/, message: "格式无效" }, unless: 'phone.blank?'
  validates :last_name, length: { maximum: 25 }
  validates :first_name, length: { maximum: 25 }
  validates :gender, presence: true, inclusion: { in: User.genders.keys, message: "格式无效" }

  def attributes
    { phone: nil, last_name: nil, first_name: nil, gender: nil }
  end
end