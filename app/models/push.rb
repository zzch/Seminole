class Push
  class << self
    def _send options = {}
      options[:platform] ||= :all
      options[:audience] ||= :all
      options[:notification] ||= { alert: 'test' }
      uri = URI.parse('https://api.jpush.cn/v3/push')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request.basic_auth Setting.key[:jpush][:api_key], Setting.key[:jpush][:api_secret]
      request.body = { platform: options[:platform], audience: options[:audience], notification: options[:notification], options: { apns_production: false } }.to_json
      http.request(request)
    end

    def send_by_registration_id registration_id, options = {}
      _send({ audience: { registration_id: [registration_id]} }.merge(options))
    end

    def send_all

    end
  end
end
