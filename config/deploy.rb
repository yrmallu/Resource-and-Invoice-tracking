server "54.235.158.17", :app, :web, :db, :primary => true

set :application, "magnifiit.com"
set :deploy_to, "/var/www/#{ application }"

set :scm, :git
set :repository,  "git@github.com:CuelogicTech/cuelogic-hrms.git"
set :scm_verbose, true

set :branch, "master"

# set :scm_passphrase, "password"
set :use_sudo, false

set :user, "ubuntu"

default_run_options[:pty] = true

set :deploy_via, :copy

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

ssh_options[:keys] = %w(/home/cuelogic/Documents/cuelogic-hrms.pem)
set :keep_releases, 5

set :rails_env, "production"


# tasks
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Symlink shared resources on each release - not used"
  task :symlink_shared, :roles => :app do
    #run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

after "deploy", "deploy:restart"
after "deploy", "deploy:cleanup"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end