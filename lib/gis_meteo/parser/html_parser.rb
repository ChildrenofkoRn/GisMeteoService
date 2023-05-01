module GisMeteo
  class HtmlParser

    DATE_FORMAT = '%F %T %:z'

    def initialize(html)
      @html = Nokogiri::HTML(html)
    end

    def updated_at
      Time.now.strftime(DATE_FORMAT)
    end

    def location
      @html.css('.search.js-search > .transparent-city.js-transparent-city').text
    end

    def url
      @html.at('meta[property="og:url"]')['content']
    end

    def temperature
      @html.css('.now-weather > span.unit.unit_temperature_c').text
    end

    def feel
      @html.css('.now-feel > span.unit.unit_temperature_c').children.text
    end

    def cloudiness
      @html.css('.now-desc').text
    end

    def wind
      wind_html = @html.css('.now-info-item.wind > .item-value > .unit.unit_wind_m_s')

      metric, direction = wind_direction(wind_html)
      "#{wind_value(wind_html)} #{metric} #{direction}"
    end

    def pressure
      @html.css('.unit.unit_pressure_mm_hg_atm').children.first.text
    end

    def sunset
      @html.css('.now-astro-sunset').children.map(&:text).join(' ')
    end

    def sunrise
      @html.css('.now-astro-sunrise').children.map(&:text).join(' ')
    end

    def humidity
      @html.css('.now-info-item.humidity > .item-value').children.text
    end

    private

    def wind_value(wind_html)
      wind_html.children.first.text
    end

    def wind_direction(wind_html)
      wind_html.css('.item-measure').children.map(&:text)
    end

  end
end
