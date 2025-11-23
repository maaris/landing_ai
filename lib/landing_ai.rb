require_relative "landing_ai/version"
require_relative "landing_ai/client"
require_relative "landing_ai/ade_parse"
require_relative "landing_ai/ade_extract"

module LandingAI
  class Error < StandardError; end

  class << self
    attr_accessor :api_key

    def configure
      yield self
    end
  end
end
