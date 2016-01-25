# -*- encoding : utf-8 -*-
module UUID
  def self.included(base)
    base.extend(ClassMethods)
    base.before_create :set_uuid
  end

  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end

  module ClassMethods
    def find_uuid uuid
      self.where(uuid: uuid).first || raise(ActiveRecord::RecordNotFound)
    end

    def rebuild_uuid!
      self.all.select{|m| m.uuid.blank?}.each do |m|
        m.update!(uuid: SecureRandom.uuid)
      end
    end
  end
end
