class OperatorBehavior < ActiveRecord::Base
  belongs_to :operator
  as_enum :type, [:generate, :sign_in, :service_process], map: :string

  self.types.keys.each do |content|
    define_singleton_method "#{type}!" do |content|
      create!(type: type, content: content)
    end
  end
end