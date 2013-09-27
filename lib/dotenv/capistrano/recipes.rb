Capistrano::Configuration.instance(:must_exist).load do
  _cset(:dotenv_path){ "#{shared_path}/.env" }
  _cset(:dotenv_role){ [:app] }

  namespace :dotenv do
    desc "Symlink shared .env to current release"
    task :symlink, roles: lambda { dotenv_role } do
      run "ln -nfs #{dotenv_path} #{release_path}/.env"
    end
  end
end
