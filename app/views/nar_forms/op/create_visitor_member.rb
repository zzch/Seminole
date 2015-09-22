class Op::CreateVisitorMember < BaseNarForm
  attr_accessor :phone, :first_name, :last_name, :gender
  validates :phone, format: { with: /\A1[0-9]{10}\z/, message: "格式无效" }, if: 'phone', on: :create
  validates :first_name, length: { maximum: 25 }
  validates :last_name, length: { maximum: 25 }
  validates :gender, inclusion: { in: User.genders.keys, message: "格式无效" }
end