class Sms
  class << self
    def _send options = {}
      uri = URI.parse('https://sms-api.luosimao.com/v1/send.json')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request.basic_auth 'api', "key-#{Setting.key[:luosimao_sms][:api_key]}"
      request.body =  { mobile: options[:phone], message: options[:message] }
      http.request(request)
    end
  end
end
