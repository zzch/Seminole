class Op::CreateRegularMember < BaseNarForm
  attr_accessor :phone, :first_name, :last_name, :gender
  validates :phone, presence: true, format: { with: /\A1[0-9]{2} - [0-9]{4} - [0-9]{4}\z/, message: "格式无效" }
  validates :last_name, length: { maximum: 25 }, presence: true
  validates :first_name, length: { maximum: 25 }, presence: true
  validates :gender, presence: true, inclusion: { in: User.genders.keys, message: "格式无效" }
  validates_with DuplicatedPhoneValidator
end