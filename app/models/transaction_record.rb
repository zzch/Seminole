class TransactionRecord < ActiveRecord::Base
	belongs_to :member
	belongs_to :operator
	belongs_to :tab
  as_enum :type, [:income, :expenditure], prefix: true, map: :string
end