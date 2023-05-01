module GisMeteo
  module Request
    def self.get(url, proxy = nil)
      request = Faraday.new(url: url) do |req|
        # throws an exception on 4xx or 5xx responses
        req.response :raise_error
        req.proxy = Proxy.new(proxy).to_url
      end

      begin
        response = request.get
      rescue => ex
        puts "Error request: #{ex.message}"
        ''
      else
        response.body
      end
    end
  end
end
