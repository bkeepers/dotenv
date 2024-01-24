#!/usr/bin/env rake

require "bundler/gem_helper"
require "rspec/core/rake_task"
require "rake/testtask"
require "standard/rake"

namespace "dotenv" do
  Bundler::GemHelper.install_tasks name: "dotenv"
end

class DotenvRailsGemHelper < Bundler::GemHelper
  def guard_already_tagged
    # noop
  end

  def tag_version
    # noop
  end
end

namespace "dotenv-rails" do
  DotenvRailsGemHelper.install_tasks name: "dotenv-rails"
end

task build: ["dotenv:build", "dotenv-rails:build"]
task install: ["dotenv:install", "dotenv-rails:install"]
task release: ["dotenv:release", "dotenv-rails:release"]

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w[--color]
  t.verbose = false
end

Rake::TestTask.new do |t|
  t.test_files = Dir["test/**/*_test.rb"]
end

task default: [:spec, :test, :standard]
