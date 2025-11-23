RSpec.describe LandingAI::AdeParse do
  let(:client) { LandingAI::Client.new(api_key: "test_key") }
  let(:service) { described_class.new(client: client) }

  describe "#call" do
    context "with document_url" do
      it "parses the document from URL" do
        stub_request(:post, "https://api.va.landing.ai/v1/ade/parse")
          .with(
            body: { "document_url" => "https://example.com/doc.pdf" },
            headers: {
              "Authorization" => "Bearer test_key"
            }
          )
          .to_return(status: 200, body: { markdown: "Parsed content" }.to_json)

        response = service.call(document_url: "https://example.com/doc.pdf")
        expect(response["markdown"]).to eq("Parsed content")
      end
    end

    context "with document file" do
      let(:file_path) { "spec/fixtures/test.pdf" }

      before do
        FileUtils.mkdir_p("spec/fixtures")
        File.write(file_path, "dummy pdf content")
      end

      after do
        FileUtils.rm_f(file_path)
      end

      it "parses the document from file" do
        stub_request(:post, "https://api.va.landing.ai/v1/ade/parse")
          .with(
            headers: {
              "Authorization" => "Bearer test_key",
              "Content-Type" => %r{multipart/form-data}
            }
          )
          .to_return(status: 200, body: { markdown: "Parsed content" }.to_json)

        response = service.call(document: file_path)
        expect(response["markdown"]).to eq("Parsed content")
      end
    end

    context "with missing arguments" do
      it "raises an error" do
        expect { service.call }.to raise_error(LandingAI::Error, /Either document or document_url must be provided/)
      end
    end
  end
end
