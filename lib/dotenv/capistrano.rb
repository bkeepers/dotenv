require 'dotenv/capistrano/recipes'

Capistrano::Configuration.instance(:must_exist).load do
  before "deploy:finalize_update", "dotenv:symlink"
end
