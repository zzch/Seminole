class VerificationCode < ActiveRecord::Base
  belongs_to :user
  as_enum :type, [:sign_in], prefix: true, map: :string
  scope :unused, -> { where(used: false) }
  scope :used, -> { where(used: true) }

  def expired?
    Time.now <= self.expired_at
  end

  def expired!
    update!(used: true)
  end

  class << self
    def generate_and_send options = {}
      #raise FrequentRequest.new if Time.now - (where(user_id: options[:user].id).where(type_cd: options[:type]).order(created_at: :desc).first.try(:created_at) || Time.now - 1.hour) < 1.minute
      #raise TooManyRequest.new if where(phone: options[:phone]).where('created_at >= ?', Time.now.beginning_of_day).where('created_at <= ?', Time.now.end_of_day).count > 15
      content = rand(1234..9876)
      create!(user: options[:user], type: options[:type], phone: (options[:phone] || options[:user].phone), content: content, expired_at: Time.now + 30.minutes)
      if Rails.env.production? and options[:phone] != 13911320927
        Sms._send(phone: options[:phone], message: "您的验证码为#{content}，请勿泄露给他人。【练球宝】")
      end
    end

    def send_sign_in options = {}
      raise UnactivatedUser.new unless options[:user].activated?
      generate_and_send(user: options[:user], phone: options[:phone], type: :sign_in)
    end

    def validate_sign_in options = {}
      if Rails.env.production?
        raise IncorrectVerificationCode.new unless options[:verification_code].to_s == options[:user].verification_codes.type_sign_ins.order(created_at: :desc).first.try(:content)
      else
        raise IncorrectVerificationCode.new unless options[:verification_code].to_s == '8888'
      end
    end
  end
end