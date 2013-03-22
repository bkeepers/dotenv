# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dotenv/version', __FILE__)

Gem::Specification.new do |gem|
  gem.version       = Dotenv::VERSION
  gem.authors       = ["Brandon Keepers"]
  gem.email         = ["brandon@opensoul.org"]
  gem.description   = %q{Autoload dotenv in Rails.}
  gem.summary       = %q{Autoload dotenv in Rails.}
  gem.homepage      = "https://github.com/bkeepers/dotenv"

  gem.files         = ["lib/dotenv-rails.rb"]
  gem.name          = "dotenv-rails"
  gem.require_paths = ["lib"]

  gem.add_dependency 'dotenv', Dotenv::VERSION
end
