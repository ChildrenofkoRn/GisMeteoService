require_relative 'data_weather'
require_relative 'data_static'

module WeatherService
  class App

    TYPES = {
      xml:  'application/xml, text/xml',
      html: 'text/html',
      webp: 'image/webp'
    }

    def initialize
      @weather = DataWeather.new(
        locations:   WeatherService.config.locations,
        update_time: WeatherService.config.refresh_rate_minutes,
        proxy:       WeatherService.config.proxy
      ).run
    end

    def call(env)
      request = Rack::Request.new(env)

      case request.path_info
      when /^\/weather\/(?<name>(\w|-)+)\/?$/ then response_weather($~[:name])
      when /^\/weather\/?$/ then response_weathers_locations
      when /\/olusha.webp$/ then response_picture
      when /\/favicon.ico$/ then response_not_found
      else response_main(request.ip)
      end

    rescue => ex
      WeatherService.logger.error(ex.full_message)
      response_internal_server_error
    end

    private

    def response_weather(name_location)
      response_base(:xml, @weather.get(name_location))
    end

    def response_weathers_locations
      response_base(:html, DataStatic.locations(@weather.locations))
    end

    def response_main(ip)
      response_base(:html, DataStatic.main_olusha(ip))
    end

    def response_picture
      response_base(:webp, DataStatic.olusha_webp)
    end

    def response_not_found
      response_base(:html, '', 404)
    end

    def response_internal_server_error
      response_base(:html, '', 500)
    end

    def response_base(content_type, content, status = 200)
      response = Rack::Response.new do |res|
        res.content_type = TYPES[content_type]
        res.body         = [content]
        res.status       = status
      end

      response.finish
    end
  end
end
