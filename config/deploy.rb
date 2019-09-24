# config valid for current version and patch releases of Capistrano
lock "~> 3.11.1"

set :application, "SmartMenu"
set :repo_url, "git@github.com:shirotaro3/SmartMenu.git"

# Default branch is :master
set :branch, 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/SmartMenu"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push("config/settings.yml",'config/master.key')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push("log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system")

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# 保持するバージョンの個数(※後述)
set :keep_releases, 5

# rubyのバージョン
set :rbenv_ruby, '2.5.5'

#出力するログのレベル。
set :log_level, :debug

namespace :deploy do
  
    desc "Restart Application"
    task :restart do
      on roles(:app), in: :sequence, wait: 5 do
        invoke 'puma:restart'
      end
    end

    desc 'Create database'
    task :db_create do
      on roles(:db) do |host|
        with rails_env: fetch(:rails_env) do
          within current_path do
            execute :bundle, :exec, :rake, 'db:create'
          end
        end
      end
    end
  
    desc 'Run seed'
    task :seed do
      on roles(:app) do
        with rails_env: fetch(:rails_env) do
          within current_path do
            execute :bundle, :exec, :rake, 'db:seed'
          end
        end
      end
    end
  
  
    after :restart, :clear_cache do
      on roles(:web), in: :groups, limit: 3, wait: 10 do
      end
    end
  end