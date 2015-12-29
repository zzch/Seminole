class Preference < ActiveRecord::Base
  include ApplicationHelper, BracHelper
  belongs_to :club

  def to_value human_readable = false
    case self.name.to_sym
    when :print_receipt
      human_readable ? brac_boolean(self.value.to_bool) : self.value.to_bool
    end
  end

  class << self
    def default_value_of name
      case name
      when :print_receipt then 'false'
      end
    end
  end
end