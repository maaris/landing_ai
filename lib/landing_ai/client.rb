require "faraday"
require "faraday/net_http"
require "faraday/multipart"

module LandingAI
  class Client
    BASE_URL = "https://api.va.landing.ai/v1"

    def initialize(api_key: nil)
      @api_key = api_key || LandingAI.api_key
      raise Error, "API key is required" if @api_key.nil?
    end

    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |conn|
        conn.request :multipart
        conn.request :url_encoded
        conn.adapter :net_http
        conn.headers["Authorization"] = "Bearer #{@api_key}"
      end
    end
  end
end
