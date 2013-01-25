# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version       = '0.5.0'
  gem.authors       = ["Brandon Keepers"]
  gem.email         = ["brandon@opensoul.org"]
  gem.description   = %q{Loads environment variables from `.env`.}
  gem.summary       = %q{Loads environment variables from `.env`.}
  gem.homepage      = "https://github.com/bkeepers/dotenv"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "dotenv"
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
