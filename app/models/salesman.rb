class Salesman < ActiveRecord::Base
  include UUID
  belongs_to :club
  has_many :members

  def send_sms options = {}
    if !!(self.phone =~ /\A1\d{10}\Z/) and self.receive_sms?
      Sms._send(phone: self.phone, message: options[:message])
    end
  end
end