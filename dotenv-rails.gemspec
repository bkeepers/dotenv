# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dotenv/version', __FILE__)

Gem::Specification.new do |gem|
  gem.version       = Dotenv::VERSION
  gem.authors       = ["Brandon Keepers"]
  gem.email         = ["brandon@opensoul.org"]
  gem.description   = %q{Autoload dotenv in Rails.}
  gem.summary       = %q{Autoload dotenv in Rails.}
  gem.homepage      = "https://github.com/bkeepers/dotenv"
  gem.license       = 'MIT'

  gem.files         = `git ls-files | grep rails`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "dotenv-rails"
  gem.require_paths = ["lib"]

  gem.add_dependency 'dotenv', Dotenv::VERSION

  gem.add_development_dependency 'spring'
  gem.add_development_dependency 'railties'
end
