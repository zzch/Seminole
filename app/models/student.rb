class Student < ActiveRecord::Base
  include UUID, AASM
  attr_accessor :expired_at_date
  belongs_to :user
  belongs_to :course
  aasm column: 'state' do
    state :progressing, initial: true
    state :finished
    state :cancelled
    state :expired
  end
end