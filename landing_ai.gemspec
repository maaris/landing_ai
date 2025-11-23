# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "landing_ai"
  spec.version       = "0.1.0"
  spec.authors       = ["Antigravity"]
  spec.email         = ["antigravity@example.com"]

  spec.summary       = "Ruby client for Landing AI API"
  spec.description   = "A Ruby gem to interact with Landing AI's ADE Parse and other tools."
  spec.homepage      = "https://github.com/example/landing_ai"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 2.0", "< 2.8"
  spec.add_dependency "faraday-net_http", "< 3.0"
  spec.add_dependency "faraday-multipart", "~> 1.0"

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "webmock", "~> 3.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
