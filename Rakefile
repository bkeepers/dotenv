#!/usr/bin/env rake

require "bundler/gem_helper"

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

require "rspec/core/rake_task"

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w[--color]
  t.verbose = false
end

require "standard/rake"

task default: [:spec, :standard]
