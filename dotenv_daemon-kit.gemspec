# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dotenv/version', __FILE__)

Gem::Specification.new do |gem|
  gem.version       = Dotenv::VERSION
  gem.authors       = ["Brandon Keepers"]
  gem.email         = ["brandon@opensoul.org"]
  gem.description   = %q{Autoload dotenv in DaemonKit.}
  gem.summary       = %q{Autoload dotenv in DaemonKit.}
  gem.homepage      = "https://github.com/bkeepers/dotenv"

  gem.files         = ["lib/dotenv/daemon-kit.rb"]
  gem.name          = "dotenv_daemon-kit"
  gem.require_paths = ["lib"]

  gem.add_dependency 'dotenv', Dotenv::VERSION
end
