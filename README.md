# LandingAI Ruby Gem

A Ruby client for the [Landing AI API](https://landing.ai/). Currently supports the ADE Parse tool.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'landing_ai'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install landing_ai

## Compatibility

This gem is compatible with **Ruby 2.6+**.

## Configuration

Configure the gem with your API key:

```ruby
require 'landing_ai'

LandingAI.configure do |config|
  config.api_key = 'your_api_key_here'
end
```

## Usage

### ADE Parse

Parse documents (PDF, images) into structured Markdown.

#### Parse from URL

```ruby
client = LandingAI::AdeParse.new
result = client.call(document_url: "https://example.com/document.pdf")

puts result["markdown"]
```

#### Parse from Local File

```ruby
client = LandingAI::AdeParse.new
result = client.call(document: "/path/to/document.pdf")

puts result["markdown"]
```

#### Options

You can also specify the `model` and `split` parameters:

```ruby
client.call(
  document_url: "...",
  model: "dpt-2-latest", # Optional
  split: "page"          # Optional: split by page
)
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
