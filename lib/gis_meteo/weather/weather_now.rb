module GisMeteo
  class WeatherNow

    PROPS = %i[ updated_at location url temperature feel cloudiness wind pressure humidity sunset sunrise ]

    attr_reader *PROPS

    def initialize(parser)
      PROPS.each do |attr|
        value = parser.public_send(attr)
        instance_variable_set("@#{attr}", value)
      end
    end

    def to_h
      PROPS.each_with_object({}) do |prop, hash_export|
        hash_export[prop] = public_send(prop)
      end
    end

    def to_xml
      hash = self.to_h

      Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.weather {
          hash.each_pair do |key, value|
            value  = value.empty? ? 'n/a' : value
            xml.public_send(key, value)
          end
        }
      end.to_xml
    end
  end
end
