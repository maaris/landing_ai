require "bundler/setup"
require "landing_ai"

# Usage: API_KEY=your_key bundle exec ruby demo.rb

LandingAI.configure do |config|
  config.api_key = ENV["API_KEY"]
end

if ENV["API_KEY"].nil?
  puts "Please provide API_KEY environment variable"
  exit 1
end

puts "Parsing URL..."
begin
  result = LandingAI::AdeParse.new.call(
    document_url: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
  )
  puts "Success! Markdown length: #{result['markdown'].length}"
  puts "Snippet: #{result['markdown'][0..100]}..."
rescue => e
  puts "Error: #{e.message}"
end
