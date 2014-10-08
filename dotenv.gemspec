# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dotenv/version', __FILE__)

Gem::Specification.new do |gem|
  gem.version       = Dotenv::VERSION
  gem.authors       = ["Brandon Keepers"]
  gem.email         = ["brandon@opensoul.org"]
  gem.description   = %q{Loads environment variables from `.env`.}
  gem.summary       = %q{Loads environment variables from `.env`.}
  gem.homepage      = "https://github.com/bkeepers/dotenv"
  gem.license       = 'MIT'

  gem.files         = `git ls-files | grep -v rails`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "dotenv"
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
