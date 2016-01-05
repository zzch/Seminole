class Operator < ActiveRecord::Base
  include AASM
  attr_accessor :password
  before_create :hash_password
  belongs_to :club
  aasm column: 'state' do
    state :available, initial: true
    state :prohibited
    state :trashed
    event :prohibit do
      transitions from: :available, to: :prohibited
    end
    event :trash do
      transitions to: :trashed
    end
  end
  validates :account, presence: true, length: { in: 4..16 }, format: { with: /\A[A-Za-z0-9_]+\z/, message: "只能使用字母、数字和下划线" }
  validates :password, presence: true, confirmation: true, length: { in: 4..16 }, format: { with: /\A[A-Za-z0-9!@#$%^&*(),.?]+\z/, message: "只能使用字母、数字和符号" }, on: :create
  validates :name, presence: true, length: { maximum: 50 }

  def authenticate password
    self.hashed_password == Digest::MD5.hexdigest(password) ? self : nil
  end

  def update_password password
    self.update(hashed_password: Digest::MD5.hexdigest(password))
  end

  protected
    def hash_password
      self.hashed_password = Digest::MD5.hexdigest(self.password)
    end
end