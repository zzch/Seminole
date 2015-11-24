class Push < ActiveRecord::Base
  class << self
    def request options = {}
      options[:platform] ||= :all
      options[:audience] ||= :all
      options[:notification] ||= { alert: 'test' }
      options[:message] ||= { msg_content: 'test' }
      uri = URI.parse("https://api.jpush.cn/v3/push")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request.basic_auth Setting.key[:jpush][:api_key], Setting.key[:jpush][:api_secret]
      request.body = { platform: options[:platform], audience: options[:audience], notification: options[:notification], message: options[:message] }.to_json
      response = http.request(request)
    end

    def send_by_cid

    end

    def send_all

    end
  end
end
