Capistrano::Configuration.instance(:must_exist).load do
  _cset(:dotenv_path){ "#{shared_path}/.env" }

  symlink_args = (role = fetch(:dotenv_role, nil) ? {:roles => role} : {})

  namespace :dotenv do
    desc "Symlink shared .env to current release"
    task :symlink, symlink_args do
      run "ln -nfs #{dotenv_path} #{release_path}/.env"
    end
  end
end
