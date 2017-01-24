source "https://rubygems.org"
gemspec :name => "dotenv"
gemspec :name => "dotenv-rails"

group :guard do
  gem "guard-rspec"
  gem "guard-bundler"
  gem "rb-fsevent"
end

platforms :rbx do
  gem "rubysl", "~> 2.0" # if using anything in the ruby standard library
end

if Gem::Version.create(RUBY_VERSION) < Gem::Version.create("2.2.2")
  # Rack 2 requires Ruby version >= 2.2.2
  gem "rack", ">= 1.6.5", "< 2.0.0"
end

if Gem::Version.create(RUBY_VERSION) < Gem::Version.create("2.1.0")
  # Nokogiri 1.7 requires Ruby version >= 2.1.0.
  gem "nokogiri", ">= 1.6.8", "< 1.7.0"
end
