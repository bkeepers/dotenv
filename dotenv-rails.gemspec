require File.expand_path('../lib/dotenv/version', __FILE__)

Gem::Specification.new "dotenv-rails", Dotenv::VERSION do |gem|
  gem.authors       = ["Brandon Keepers"]
  gem.email         = ["brandon@opensoul.org"]
  gem.description   = gem.summary = "Autoload dotenv in Rails."
  gem.homepage      = "https://github.com/bkeepers/dotenv"
  gem.license       = 'MIT'
  gem.files         = `git ls-files lib | grep rails`.split($\) + ["README.md", "LICENSE"]

  gem.add_dependency 'dotenv', Dotenv::VERSION

  gem.add_development_dependency 'spring'
  gem.add_development_dependency 'railties'
end
