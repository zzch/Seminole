class User < ActiveRecord::Base
  include UUID
  mount_uploader :portrait, UserPortraitUploader
  as_enum :gender, [:male, :female], prefix: true, map: :string
  has_many :memberships
  has_many :members, through: :memberships

  def name
    "#{last_name}#{first_name}"
  end

  def human_gender
    case self.gender
    when :male then '先生'
    when :female then '女士'
    end
  end

  def nearest_club latitude, longitude
    if self.members.count == 1
      self.members.first.club
    elsif latitude.nil? or longitude.nil?
      self.members.last.club
    else
      Club.where(id: self.members.map(&:club_id)).nearest(latitude, longitude).first
    end
  end

  def membership_clubs
    self.members.map(&:club).uniq
  end

  def sign_out
    update!(token: nil)
  end

  class << self
    def sign_in phone, verification_code
      where(phone: phone).first.tap do |user|
        raise UserNotFound.new if user.nil?
        raise UnactivatedUser.new unless user.activated?
        raise IncorrectVerificationCode.new if verification_code != 8888
        user.update!(token: SecureRandom.urlsafe_base64)
      end
    end

    def find_or_create_visitor attributes
      if !attributes.phone.blank? and (exist_user = where(phone: attributes.phone).first)
        exist_user
      else
        create!(attributes.serializable_hash.merge(activated: false))
      end
    end

    def find_or_create_member attributes
      if exist_user = where(phone: attributes.phone).first
        exist_user
      else
        create!(phone: attributes.phone, first_name: attributes.first_name, last_name: attributes.last_name, gender: attributes.gender, activated: true)
      end
    end

    def authorize token
      where(activated: true).where(token: token).first
    end
  end
end