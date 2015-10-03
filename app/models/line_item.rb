class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :tee
  as_enum :type, [:primary, :secondary], map: :string
end