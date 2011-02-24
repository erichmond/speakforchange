set :application, "rails"
set :repository,  "http://speakforchange.googlecode.com/svn/trunk/#{application}"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/goat/speak4change/#{application}"

set :user, "goat"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "66.160.141.232"
role :web, "66.160.141.232"
role :db,  "66.160.141.232", :primary => true

after "deploy:finalize_update", "deploy:link_to_messages"
after "deploy:restart", "deploy:search_stop"
after "deploy:restart", "deploy:search_config"
after "deploy:restart", "deploy:search_index"
after "deploy:restart", "deploy:search_start"
#after "deploy:restart", "deploy:conversion_daemon_stop"
#after "deploy:restart", "deploy:conversion_daemon_start"


namespace :deploy do
  task :link_to_messages, :roles => :app do
    run "rm -rf #{latest_release}/public/messages && ln -s #{shared_path}/messages #{latest_release}/public/messages"
  end

  task :conversion_daemon_stop, :roles => :app do
    run "cd #{current_path} && ruby conversion_daemon.rb stop production"
  end

  task :conversion_daemon_start, :roles => :app do
    run "cd #{current_path} && ruby conversion_daemon.rb start production"
  end

  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
    # We must stop restart adhearsion since we need RAILS_ROOT to stay in sync.
    run "/home/goat/speak4change/ahn_app/shared/system/start"
  end

  task :stop, :roles => :app do
    # We must stop restart adhearsion since we need RAILS_ROOT to stay in sync.
    run "/home/goat/speak4change/ahn_app/shared/system/stop"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
    # We must stop restart adhearsion since we need RAILS_ROOT to stay in sync.
    run "/home/goat/speak4change/ahn_app/shared/system/stop"
    run "/home/goat/speak4change/ahn_app/shared/system/start"
  end
  
  desc "Config Search"
  task :search_config, :roles => :app do
    run "cd #{current_path} && sudo rake ts:config RAILS_ENV=production"
  end

  desc "Start Search"
  task :search_start, :roles => :app do
    run "cd #{current_path} && sudo rake ts:start RAILS_ENV=production"
  end

  desc "Stop Search"
  task :search_stop, :roles => :app do
    run "cd #{current_path} && sudo rake ts:stop RAILS_ENV=production"
  end

  desc "Rebuild Search"
  task :search_rebuild, :roles => :app do
    run "cd #{current_path} && sudo rake ts:stop RAILS_ENV=production"
    run "cd #{current_path} && sudo rake ts:config RAILS_ENV=production"
    run "cd #{current_path} && sudo rake ts:index RAILS_ENV=production"
    run "cd #{current_path} && sudo rake ts:start RAILS_ENV=production"
  end

  desc "Index Search"
  task :search_index, :roles => :app do
    run "cd #{current_path} && sudo rake ts:in RAILS_ENV=production"
  end
end
