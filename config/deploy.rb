# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'coltonmalone.com'
set :repo_url, 'git@github.com:cmainer/coltonmalone.com.git'
ask :branch, :master

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '~/www/coltonmalone.com'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug
set :rails_env, "production"


# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
  after :publishing, "deploy:restart"
  after :finishing, 'deploy:cleanup'
end


namespace :db do
  task :full_reset do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rake db:full_reset"
        end
      end
    end
  end
end

namespace :logs do
  desc "tail rails logs"
  task :tail do
    ################################################################################
    # Sets log level to debug so we can see program output
    ################################################################################
    set :log_level, :debug
    configure_backend

    on roles(:app) do
      execute "tail -f #{shared_path}/log/#{fetch(:rails_env)}.log"
    end
  end
end
