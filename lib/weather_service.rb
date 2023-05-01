require 'yaml'
require 'rack'
require 'logger'
require_relative 'weather_service/config'

module WeatherService

  ROOT = File.expand_path('..', __dir__)

  class << self

    TEMPLATE_LOG = proc do |severity, datetime, progname, msg|
      "[#{datetime.strftime('%Y.%m.%d %H:%M:%S')}] #{severity}: #{msg}\n"
    end

    attr_reader :config, :logger

    def app
      WeatherService::App.new
    end

    def prod?
      @config.environment.match?(/^(production|prod|deploy)$/i)
    end

    def pidfile
      @config.pidfile.nil? ? File.join(ROOT, 'weather.pid') : @config.pidfile
    end

    def read_file(path)
      IO.read(path, :encoding => 'UTF-8')
    rescue Errno::ENOENT
      puts "Something went wrong and #{path} was lost."
      exit 1
    end

    private

    def greeting
      @logger.info '=' * 70
      @logger.info 'Start application..'
      @logger.info "Environment: #{@config.environment}"
      @logger.debug "Thread.list = \n#{Thread.list.join("\n")}"
    end

    def require_app
      require File.join(ROOT, 'lib/weather_service/app.rb')
    end

    def get_logger
      if prod?
        logfile = File.join(ROOT,'logs','requests.log')
        Logger.new(logfile,
                   config.log_rotation,
                   formatter: TEMPLATE_LOG,
                   level: Logger::INFO)
      else
        Logger.new(STDOUT,
                   formatter: TEMPLATE_LOG,
                   level: Logger::DEBUG)
      end
    end

    def load_yaml
      path = File.join(ROOT, 'settings.yml')
      yaml = read_file(path)
      YAML.load(yaml, symbolize_names: true)
    end

    def load
      @config = Config.new(load_yaml)
      @logger = get_logger
      require_app
      greeting
    end
  end

  self.load
end
