class OperatorNotification < ActiveRecord::Base
  belongs_to :operator
  scope :by_operator, ->(operator_id) { where(operator_id: operator_id) }
  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }
  scope :latest, -> { order(read: :asc, created_at: :desc) }
end