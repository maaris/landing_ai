RSpec.describe LandingAI::AdeExtract do
  let(:client) { LandingAI::Client.new(api_key: "test_key") }
  let(:service) { described_class.new(client: client) }
  let(:schema) { { type: "object", properties: { name: { type: "string" } } } }

  describe "#call" do
    context "with markdown_url" do
      it "extracts data from URL" do
        stub_request(:post, "https://api.va.landing.ai/v1/ade/extract")
          .with(
            body: {
              "markdown_url" => "https://example.com/doc.md",
              "schema" => schema.to_json
            },
            headers: {
              "Authorization" => "Bearer test_key"
            }
          )
          .to_return(status: 200, body: { extraction: { name: "Test" } }.to_json)

        response = service.call(markdown_url: "https://example.com/doc.md", schema: schema)
        expect(response["extraction"]["name"]).to eq("Test")
      end
    end

    context "with markdown file" do
      let(:file_path) { "spec/fixtures/test.md" }

      before do
        FileUtils.mkdir_p("spec/fixtures")
        File.write(file_path, "# Test Name")
      end

      after do
        FileUtils.rm_f(file_path)
      end

      it "extracts data from file" do
        stub_request(:post, "https://api.va.landing.ai/v1/ade/extract")
          .with(
            headers: {
              "Authorization" => "Bearer test_key",
              "Content-Type" => %r{multipart/form-data}
            }
          )
          .to_return(status: 200, body: { extraction: { name: "Test" } }.to_json)

        response = service.call(markdown: file_path, schema: schema)
        expect(response["extraction"]["name"]).to eq("Test")
      end
    end

    context "with markdown content" do
      it "extracts data from content string" do
        stub_request(:post, "https://api.va.landing.ai/v1/ade/extract")
          .with(
            headers: {
              "Authorization" => "Bearer test_key",
              "Content-Type" => %r{multipart/form-data}
            }
          )
          .to_return(status: 200, body: { extraction: { name: "Test" } }.to_json)

        response = service.call(markdown: "# Test Name", schema: schema)
        expect(response["extraction"]["name"]).to eq("Test")
      end
    end

    context "with missing arguments" do
      it "raises an error" do
        expect { service.call(schema: schema) }.to raise_error(LandingAI::Error, /Either markdown or markdown_url must be provided/)
      end
    end
  end
end
