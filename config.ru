require_relative 'rack/common_logger_with_ua'
require_relative 'lib/weather_service'

config = WeatherService.config

app = Rack::Builder.app do
  use Rack::CommonLoggerWithUA, WeatherService.logger
  run WeatherService.app
end

# AccessLog: [] disable AccessLog WebRick
Rackup::Server.new(app: app,
                   Host: config.host,
                   Port: config.port,
                   server: config.server,
                   environment: config.environment,
                   logger: WeatherService.logger,
                   AccessLog: [],
                   # manual selection of the server if necessary
                   # ServerType: WEBrick::SimpleServer,
                   pid: WeatherService.pidfile,
                   warmup: true).start

# just type "rackup" in the terminal to run
#
#
#
# you can change the startup parameters using settings.yml
#
# examples:
#
# locations - simply add the desired locations available on the website.
#   the link should be to the page with the current weather
#   such links have the ending /now/
#
# refresh_rate_minutes - weather update period in minutes
#
# environment:
#   production, prod or deploy the log will be written to a file, otherwise STDOUT
#   as well as the logger level will be set to INFO, otherwise DEBUG
#
# log_rotation: 'weekly' or 'monthly', this is the standard Logger
#
# pidfile - you can specify the path where the pid should be saved
#
# you can use a proxy to retrieve data from the GisMeteo site:
#
# proxy:
#   host: proxy_ip
#   port: 3128
#   user: weather
#   pass: strong_pass
#
