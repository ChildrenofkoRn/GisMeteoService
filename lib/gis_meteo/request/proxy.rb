module GisMeteo
  class Proxy
    ALLOW_ATTR = %i[host port user pass]
    TPL_URL    = "http://%<user>s:%<pass>s@%<host>s:%<port>s"

    def initialize(hash)
      @proxy = hash
    end

    def to_url
      valid? ? format(TPL_URL, @proxy) : ''
    end

    def valid?
      return false if @proxy.nil?
      ALLOW_ATTR.all? {|key| !@proxy[key].nil? }
    end
  end
end
