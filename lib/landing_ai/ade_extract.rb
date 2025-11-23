require "json"

module LandingAI
  class AdeExtract
    ENDPOINT = "/v1/ade/extract"

    def initialize(client: nil)
      @client = client || Client.new
    end

    def call(markdown: nil, markdown_url: nil, schema:, model: nil)
      payload = {}
      payload[:model] = model if model
      payload[:schema] = schema.is_a?(String) ? schema : schema.to_json

      if markdown
        if File.exist?(markdown)
          payload[:markdown] = Faraday::UploadIO.new(markdown, "text/markdown")
        else
          # If it's raw content, we might need to send it as a file or just string.
          # The API docs say "The Markdown file or Markdown content".
          # Faraday multipart usually expects a file-like object or UploadIO for files.
          # If it's content, we can probably pass it directly if the API accepts it as a string field,
          # but usually "markdown=@..." implies a file upload.
          # Let's assume for now it handles file paths or we need to wrap content in a StringIO if it's raw text.
          # However, to be safe and consistent with "markdown=@markdown.md" in curl, let's treat it as a file upload if it's a path,
          # and maybe just a string if it's content?
          # Actually, `Faraday::UploadIO` is for files.
          # If `markdown` is passed and it's NOT a file path, it's likely content.
          # We can wrap it in an UploadIO with a StringIO.
          
          if markdown.length < 255 && File.exist?(markdown)
             payload[:markdown] = Faraday::UploadIO.new(markdown, "text/markdown")
          else
             # Treat as content
             payload[:markdown] = Faraday::UploadIO.new(StringIO.new(markdown), "text/markdown", "content.md")
          end
        end
      elsif markdown_url
        payload[:markdown_url] = markdown_url
      else
        raise Error, "Either markdown or markdown_url must be provided"
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
