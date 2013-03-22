#!/usr/bin/env rake

require 'bundler/gem_helper'
%w(dotenv dotenv-rails).each do |name|
  namespace name do
    Bundler::GemHelper.install_tasks :name => name
  end

  task :build => "#{name}:build"
  task :install => "#{name}:install"
  task :release => "#{name}:release"
end

require 'rspec/core/rake_task'

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w[--color]
  t.verbose = false
end

task :default => :spec
