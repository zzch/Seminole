module V1
  class TokenParam
    attr_reader :value
    def initialize(token)
      @value = token
    end

    def self.parse(value)
      fail 'Invalid token' unless value =~ /\A[A-Za-z0-9_]{22}\z/
      new(value)
    end
  end

  class UUIDParam
    attr_reader :value
    def initialize(club_uuid)
      @value = club_uuid
    end

    def self.parse(value)
      if Rails.env != 'development' or value != 'seairy'
        fail 'Invalid uuid' unless value =~ /\A[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}\z/
      end
      new(value)
    end
  end
end