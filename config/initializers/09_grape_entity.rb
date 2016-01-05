module V1
  Grape::Entity.class_eval do
    format_with(:timestamp) do |datetime|
      case datetime.class.to_s
      when 'Date' then datetime.to_datetime.to_i
      else datetime.to_i
      end unless datetime.nil?
    end

    format_with(:price) do |price|
      "#{sprintf('%0.02f', price)}元" unless price.blank?
    end

    format_with(:float) do |float|
      float.try(:to_f)
    end

    def sanitize content
      content.gsub(/(<[^>]+>|&nbsp;|\r|\n)/,"") unless content.nil?
    end
  end
end
