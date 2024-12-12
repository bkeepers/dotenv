source "https://rubygems.org"
gemspec name: "dotenv"
gemspec name: "dotenv-rails"

gem "railties", "~> #{ENV["RAILS_VERSION"] || "7.1"}"
gem "benchmark-ips"
gem "stackprof"

group :guard do
  gem "guard-rspec"
  gem "guard-bundler"
  gem "rb-fsevent"
end
