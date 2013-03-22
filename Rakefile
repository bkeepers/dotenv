#!/usr/bin/env rake

require 'bundler/gem_helper'

namespace 'dotenv' do
  Bundler::GemHelper.install_tasks :name => 'dotenv'
end

namespace 'dotenv-rails' do
  class DotenvRailsGemHelper < Bundler::GemHelper
    def guard_already_tagged; end # noop
    def tag_version; end # noop
  end

  DotenvRailsGemHelper.install_tasks :name => 'dotenv-rails'
end

task :build => ["dotenv:build", 'dotenv-rails:build']
task :install => ["dotenv:install", 'dotenv-rails:install']
task :release => ["dotenv:release", 'dotenv-rails:release']

require 'rspec/core/rake_task'

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w[--color]
  t.verbose = false
end

task :default => :spec
