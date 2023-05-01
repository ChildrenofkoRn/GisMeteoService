# Addind UA in Rack::CommonLogger
module Rack
  class CommonLoggerWithUA < CommonLogger
    FORMAT = %{%s - %s [%s] "%s %s%s%s %s" %d %s %0.4f_s UA: %s\n}

    private

    # Log the request to the configured logger.
    def log(env, status, response_headers, began_at)
      request = Rack::Request.new(env)
      length = extract_content_length(response_headers)

      msg = sprintf(FORMAT,
                    request.ip || "-",
                    request.get_header("REMOTE_USER") || "-",
                    Time.now.strftime("%d/%b/%Y:%H:%M:%S %z"),
                    request.request_method,
                    request.script_name,
                    request.path_info,
                    request.query_string.empty? ? "" : "?#{request.query_string}",
                    request.get_header(SERVER_PROTOCOL),
                    status.to_s[0..3],
                    length,
                    Utils.clock_time - began_at,
                    request.user_agent || "-")

      msg.gsub!(/[^[:print:]\n]/) { |c| sprintf("\\x%x", c.ord) }

      logger = @logger || request.get_header(RACK_ERRORS)
      # Standard library logger doesn't support write but it supports << which actually
      # calls to write on the log device without formatting
      if logger.respond_to?(:write)
        logger.write(msg)
      else
        logger << msg
      end
    end

  end
end
