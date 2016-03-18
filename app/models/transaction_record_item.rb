class TransactionRecordItem < ActiveRecord::Base
  belongs_to :transaction_record
  as_enum :type, [:playing, :provision, :extra, :charge, :refund], prefix: true, map: :string
end