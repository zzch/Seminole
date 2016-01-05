class User < ActiveRecord::Base
  include UUID
  mount_uploader :portrait, UserPortraitUploader
  as_enum :gender, [:male, :female], prefix: true, map: :string
  has_many :memberships
  has_many :members, through: :memberships
  has_many :tabs
  has_many :reservations
  has_many :students
  has_many :curriculums
  has_many :vouchers

  def name
    if !last_name.blank? and !first_name.blank?
      "#{last_name}#{first_name}"
    elsif !last_name.blank? and first_name.blank?
      "#{last_name}#{human_gender}"
    else
      '访客'
    end
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

  def member_of? club
    members.map(&:club_id).include?(club.id)
  end

  def update_registration_id registration_id
    User.where(registration_id: registration_id).update_all(registration_id: nil)
    self.update!(registration_id: registration_id)
  end

  def send_push options = {}
    Push.send_by_registration_id(self.registration_id, options)
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
      if !attributes.phone.blank? and exist_user = where(phone: attributes.phone).first
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