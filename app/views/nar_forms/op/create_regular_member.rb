class Op::CreateRegularMember < BaseNarForm
  attr_accessor :phone, :first_name, :last_name, :gender
  validates :phone, presence: true, format: { with: /\A1[0-9]{10}\z/, message: "格式无效" }, on: :create
  validates :first_name, length: { maximum: 25 }, presence: true
  validates :last_name, length: { maximum: 25 }, presence: true
  validates :gender, presence: true
end