require "httpi/response"
require "httpi/adapter/base"

module HTTPI
  module Adapter
    module Curb
      include Base

      def setup
        require "curb"
      end

      def client
        @client ||= Curl::Easy.new
      end

      def headers
        client.headers
      end

      def headers=(headers)
        client.headers = headers
      end

      def proxy
        proxy = client.proxy_url
        proxy.kind_of?(URI) ? proxy : URI(proxy)
      end

      def proxy=(proxy)
        client.proxy_url = proxy
      end

      def auth(username, password)
        client.username = username
        client.password = password
      end

      def timeout
        client.timeout
      end

      def timeout=(timeout)
        unless timeout.is_a?(Fixnum)
          raise ArgumentError, "curb only supports integer timeout values !"
        end
        client.timeout = timeout
      end

      def get(url)
        client.url = url.to_s
        client.http_get
        respond
      end

      def post(url, body)
        client.url = url.to_s
        client.http_post body
        respond
      end

    private

      def respond
        Response.new client.response_code, client.headers, client.body_str, client.total_time
      end

    end
  end
end
