module GisMeteo
  module Weather
    def self.get(url, proxy = nil)
      html = Request.get(url, proxy)
      html_parser = HtmlParserHandler.new(html)
      WeatherNow.new(html_parser).to_xml
    end
  end
end
