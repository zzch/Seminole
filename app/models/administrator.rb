class Administrator < ActiveRecord::Base
  include AASM
  attr_accessor :password, :password_confirmation
  before_create :hash_password
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
  validates :account, presence: true, length: { maximum: 16 }
  validates :password, presence: true, length: { maximum: 16 }, on: :create
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