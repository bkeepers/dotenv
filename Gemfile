source 'https://rubygems.org'
gemspec :name => 'dotenv'
gemspec :name => 'dotenv-rails'

gem 'dotenv-deployment', :github => 'bkeepers/dotenv-deployment'

group :guard do
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'rb-fsevent'
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'         # if using anything in the ruby standard library
end
