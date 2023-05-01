require 'faraday'
require 'nokogiri'

module GisMeteo
end

require_relative 'request/proxy'
require_relative 'request/request'

require_relative 'parser/html_parser'
require_relative 'parser/html_parser_handler'

require_relative 'weather/weather'
require_relative 'weather/weather_now'
