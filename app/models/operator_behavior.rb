class OperatorBehavior < ActiveRecord::Base
  belongs_to :operator
  as_enum :type, [:generate, :sign_in, :service_process], map: :string
end