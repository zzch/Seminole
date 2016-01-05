class MemberExpense < ActiveRecord::Base
  belongs_to :member
  belongs_to :item, polymorphic: true
end