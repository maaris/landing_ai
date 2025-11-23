require "json"
module LandingAI
  class AdeParse
    ENDPOINT = "/v1/ade/parse"

    def initialize(client: nil)
      @client = client || Client.new
    end

    def call(document: nil, document_url: nil, model: nil, split: nil)
      payload = {}
      payload[:model] = model if model
      payload[:split] = split if split

      if document
        payload[:document] = Faraday::UploadIO.new(document, "application/pdf") # Adjust content type as needed or detect it
      elsif document_url
        payload[:document_url] = document_url
      else
        raise Error, "Either document or document_url must be provided"
      end

      response = @client.connection.post(ENDPOINT, payload)
      
      if response.success?
        JSON.parse(response.body)
      else
        raise Error, "API Error: #{response.status} - #{response.body}"
      end
    end
  end
end
