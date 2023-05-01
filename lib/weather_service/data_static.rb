require 'erb'

module WeatherService
  module DataStatic

    TPL_FILE_PATH     = "#{WeatherService::ROOT}/lib/weather_service/pub_static/%{file}"
    TPL_TEMPLATE_PATH = "#{WeatherService::ROOT}/lib/weather_service/tpls/%{name}.erb"

    def self.main_olusha(ip)
      template = load_erb_tpl(__method__)
      ERB.new(template, nil, '-').result(binding)
    end

    def self.locations(locations)
      template = load_erb_tpl(__method__)
      ERB.new(template, nil, '-').result(binding)
    end

    def self.load_erb_tpl(template_name)
      path = format(TPL_TEMPLATE_PATH, name: template_name)
      WeatherService.read_file(path)
    end

    def self.olusha_webp
      pic_path = format(TPL_FILE_PATH, file: 'olusha.webp')
      IO.binread(pic_path)
    end
  end
end
