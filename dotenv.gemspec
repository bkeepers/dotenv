require File.expand_path("../lib/dotenv/version", __FILE__)
require "English"

Gem::Specification.new "dotenv", Dotenv::VERSION do |gem|
  gem.authors = ["Brandon Keepers"]
  gem.email = ["brandon@opensoul.org"]
  gem.description = gem.summary = "Loads environment variables from `.env`."
  gem.homepage = "https://github.com/bkeepers/dotenv"
  gem.license = "MIT"

  gem.files = `git ls-files README.md LICENSE lib bin | grep -v dotenv-rails.rb`.split("\n")
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "standard"

  gem.required_ruby_version = ">= 3.0"

  gem.metadata = {
    "changelog_uri" => "https://github.com/bkeepers/dotenv/releases",
    "funding_uri" => "https://github.com/sponsors/bkeepers"
  }
end
