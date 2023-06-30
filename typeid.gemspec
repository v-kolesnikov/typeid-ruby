require_relative "./lib/typeid.rb"

Gem::Specification.new do |gem|
  gem.name = "typeid"
  gem.version = TypeID::VERSION
  gem.summary = "A type-safe, K-sortable, globally unique identifier inspired by Stripe IDs"
  gem.authors = ["Andrew Booth"]
  gem.homepage = "https://github.com/broothie/typeid-ruby"
  gem.license = "Apache"
  gem.metadata = { "source_code_uri" => "https://github.com/broothie/typeid-ruby" }

  gem.required_ruby_version = ">= 3.0.0"
  gem.files = Dir.glob("lib/**/*.rb")
  gem.add_runtime_dependency "uuid7", "~> 0.2.0"
  gem.add_development_dependency "rspec", "~> 3.12"
  gem.add_development_dependency "pry", "~> 0.14.2"
end
