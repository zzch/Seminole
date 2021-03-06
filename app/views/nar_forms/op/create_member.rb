class Op::CreateMember < BaseNarForm
  attr_accessor :phone, :first_name, :last_name, :gender, :card_id, :number, :salesman_id
  validates :phone, presence: true, format: { with: /\A1[0-9]{2} - [0-9]{4} - [0-9]{4}\z/, message: "格式无效" }
  validates :last_name, presence: true, length: { maximum: 25 }, unless: :exist_user?
  validates :first_name, length: { maximum: 25 }, unless: :exist_user?
  validates :gender, presence: true, inclusion: { in: User.genders.keys, message: "格式无效" }, unless: :exist_user?
  validates :card_id, presence: true
  validates :number, presence: true, length: { maximum: 50 }

  def attributes
    { phone: nil, last_name: nil, first_name: nil, gender: nil, card_id: nil, number: nil, salesman_id: nil }
  end

  def exist_user?
    !User.where(phone: phone.gsub(/[ -]/, '')).first.blank?
  end
end