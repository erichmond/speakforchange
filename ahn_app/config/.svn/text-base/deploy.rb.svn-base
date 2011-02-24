set :application, "ahn_app"
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

# Since ahnctrl is broken, and we cannot specify where the pid file goes, we need to delete the pidfile
# while we know where it is, and before the new symlink is created.  once ahnctrl works again
# we will be able to do a restart as normal.
before "deploy:symlink", "deploy:stop"

namespace :deploy do 
  task :finalize_update do 
    run "chmod -R g+w #{release_path}" 
    run "rm -rf #{release_path}/log && ln -s #{deploy_to}/shared/log #{release_path}/log" 
  end 

  task :start, :roles => :app do 
    run "#{deploy_to}/shared/system/start" 
  end

  task :stop, :roles => :app do 
    run "#{deploy_to}/shared/system/stop" 
  end

  task :restart, :roles => :app do 
    #run "#{deploy_to}/shared/system/stop" 
    run "#{deploy_to}/shared/system/start" 
  end
end