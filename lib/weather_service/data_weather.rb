require_relative '../scheduler_wave/scheduler_wave'
require_relative '../gis_meteo/gis_meteo'

module WeatherService

  class WeatherLocation
    attr_reader :url
    attr_accessor :now

    def initialize(url)
      @url = url
      @now = ''
    end
  end

  class DataWeather

    TPL_NODATA = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<weather>%s</weather>\n"
    MSG        = 'This weather location is not yet supported, contact your administrator.'

    attr_reader :locations

    def initialize(
      locations:, update_time:, proxy:,
      scheduler: SchedulerWave::Task,
      weather_source: GisMeteo::Weather
    )
      @locations      = create_locations(locations)
      @proxy          = proxy
      @task           = init_task(update_time, scheduler)
      @weather_source = weather_source
    end

    def run
      @task.run
      self
    end

    def get(name)
      check_task_running
      name = name.to_sym
      @locations.key?(name) ? @locations[name].now : TPL_NODATA % MSG
    end

    private

    # re-run thread if main app run as daemon
    def check_task_running
      @task.restart?
    end

    def init_task(refresh_time, scheduler)
      scheduler.new(
        minutes: refresh_time,
        logger: WeatherService.logger,
        block_args: @locations.values
      ) do |locations|
        locations.each do |location|
          WeatherService.logger.debug "RUN GET #{location.url}"
          # location.now = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<weather>PSEUDO</weather>\n"
          location.now = @weather_source.get(location.url, @proxy)
          sleep 1
        end
      end
    end

    def create_locations(locations)
      locations.transform_values { |url| WeatherLocation.new(url) }
    end
  end
end
