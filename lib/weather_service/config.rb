module WeatherService
  class Config
    def initialize(hash)
      @config = Struct.new(*hash.keys).new(*hash.values)
    end

    def method_missing(method_symbol, *args, &block)
      return nil unless @config.respond_to?(method_symbol)

      @config.__send__(method_symbol, *args, &block)
    end

    def respond_to_missing?(method_symbol, include_private = false)
      @config.respond_to?(method_symbol, include_private)
    end
  end
end
