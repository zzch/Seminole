class ServiceException < ActiveRecord::Base
  as_enum :module, [:public, :op, :admin], prefix: true, map: :string
end