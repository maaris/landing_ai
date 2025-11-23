RSpec.describe LandingAI do
  it "has a version number" do
    expect(LandingAI::VERSION).not_to be nil
  end

  it "can be configured with an API key" do
    LandingAI.configure do |config|
      config.api_key = "test_key"
    end
    expect(LandingAI.api_key).to eq("test_key")
  end
end
