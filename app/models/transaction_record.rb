class TransactionRecord < ActiveRecord::Base
	belongs_to :member
	belongs_to :operator
	belongs_to :tab
  as_enum :type, [:income, :expenditure], prefix: true, map: :string

  class << self
  	def create_income options = {}
  		create!(type: :income, member: options[:member], operator: options[:operator], before_amount: options[:before_amount], amount: options[:amount], after_amount: options[:after_amount], remarks: options[:remarks])
  	end

  	def create_expenditure options = {}
  		create!(type: :expenditure, member: options[:member], operator: options[:operator], before_amount: options[:before_amount], amount: options[:amount], after_amount: options[:after_amount], remarks: options[:remarks])
  	end
  end
end