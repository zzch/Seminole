class Weather < ActiveRecord::Base
  belongs_to :club
  scope :recently, ->(started_at, days) { where('date >= ?', started_at.to_date).where('date < ?', (started_at + days.days).to_date) }

  class << self
    def fetch
      Club.all.each do |club|
        uri = URI.parse("https://api.thinkpage.cn/v2/weather/future.json?city=#{club.latitude.to_f}:#{club.longitude.to_f}&language=zh-chs&unit=c&key=#{Setting.key[:thinkpage][:api_key]}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        JSON.parse(response.body)['weather'][0]['future'].each do |weather|
          Weather.find_or_create_by!(club_id: club.id, date: weather['date']).tap do |weather|
            weather.content = weather['text']
            weather.day_code = weather['code1']
            weather.night_code = weather['code2']
            weather.maximum_temperature = weather['high']
            weather.minimum_temperature = weather['low']
            weather.probability_of_precipitation = weather['cop']
            weather.wind = weather['wind']
            weather.save!
          end
        end
      end
    end
  end
end