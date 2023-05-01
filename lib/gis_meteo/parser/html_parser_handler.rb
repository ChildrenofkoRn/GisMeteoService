module GisMeteo
  class HtmlParserHandler
    def initialize(html, parser = HtmlParser)
      @object = parser.new(html)
    end

    def method_missing(method_symbol, *args, &block)
      if @object.respond_to?(method_symbol)
        @object.__send__(method_symbol, *args, &block)
      else
        'Not supported'
      end
    # in case there is an error in parsing
    # eg: *** NoMethodError Exception: undefined method `text' for nil:NilClass
    rescue NoMethodError
      'ParseError'
    end

    def respond_to_missing?(method_symbol, include_private = false)
      @object.respond_to?(method_symbol, include_private)
    end
  end
end
