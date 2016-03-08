class TransactionRecord < ActiveRecord::Base
	belongs_to :member
	belongs_to :operator
	belongs_to :tab
  as_enum :type, [:income, :expenditure], prefix: true, map: :string

  def hr_before_amount
    human_readable_amount(self.before_amount)
  end

  def hr_amount
    human_readable_amount(self.amount)
  end

  def hr_after_amount
    human_readable_amount(self.after_amount)
  end

  class << self
  	def create_income options = {}
  		create!(type: :income, member_id: options[:member_id], operator_id: options[:operator_id], tab_id: options[:tab_id], before_amount: options[:before_amount], amount: options[:amount], after_amount: options[:after_amount], remarks: options[:remarks])
  	end

  	def create_expenditure options = {}
  		create!(type: :expenditure, member_id: options[:member_id], operator_id: options[:operator_id], tab_id: options[:tab_id], before_amount: options[:before_amount], amount: options[:amount], after_amount: options[:after_amount], remarks: options[:remarks])
  	end
  end

  protected
    def human_readable_amount amount
      case self.member.card.type
      when :by_ball then "#{(amount / self.member.club.balls_per_bucket).round}筐球"
      when :by_time then "#{(amount / 60).round}小时"
      when :stored then "#{amount}元"
      end
    end
end