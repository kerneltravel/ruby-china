# coding: utf-8
set :application, "ruby-china"
set :repository,  "git@github.com:kerneltravel/ruby-china.git"
set :branch, "master"
set :scm, :git
set :user, "lyl"
#set :deploy_to, "/home/#{user}/www/#{application}"
set :deploy_to, "/home/#{user}/oss/#{application}"
set :runner, "lyl"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1

#role :web, "58.215.172.218"                          # Your HTTP server, Apache/etc
#role :app, "58.215.172.218"                          # This may be the same as your `Web` server
#role :db,  "58.215.172.218", :primary => true # This is where Rails migrations will run

role :web, "127.0.0.1"                          # Your HTTP server, Apache/etc
role :app, "127.0.0.1"                          # This may be the same as your `Web` server
role :db,  "127.0.0.1", :primary => true # This is where Rails migrations will run

# unicorn.rb 路径
set :unicorn_path, "#{deploy_to}/current/config/unicorn.rb"

namespace :deploy do
  task :start, :roles => :app do
    run "cd #{deploy_to}/current/; RAILS_ENV=production unicorn_rails -c #{unicorn_path} -D"
  end

  task :stop, :roles => :app do
    run "kill -QUIT `cat #{deploy_to}/current/tmp/pids/unicorn.pid`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "kill -USR2 `cat #{deploy_to}/current/tmp/pids/unicorn.pid`"
  end
end


task :init_shared_path, :roles => :web do
  run "mkdir -p #{deploy_to}/shared/log"
  run "mkdir -p #{deploy_to}/shared/pids"
  run "mkdir -p #{deploy_to}/shared/assets"
end

task :link_shared_files, :roles => :web do
  run "ln -sf #{deploy_to}/shared/cached-copy/config/config.yml #{deploy_to}/current/config/"
  run "ln -sf #{deploy_to}/shared/cached-copy/config/mongoid.yml #{deploy_to}/current/config/"
  run "ln -sf #{deploy_to}/shared/cached-copy/config/redis.yml #{deploy_to}/current/config/"
  run "ln -sf #{deploy_to}/shared/cached-copy/config/unicorn.rb #{deploy_to}/current/config/"
  run "ln -s #{deploy_to}/shared/assets #{deploy_to}/current/public/assets"
end

task :restart_resque, :roles => :web do
  run "cd #{deploy_to}/current/; RAILS_ENV=production ./script/resque stop; RAILS_ENV=production ./script/resque start"
end

task :restart_resque, :roles => :web do
  run "cd #{deploy_to}/current/; RAILS_ENV=production ./script/resque stop; RAILS_ENV=production ./script/resque start"
end

task :install_gems, :roles => :web do  	
  run "cd #{deploy_to}/current/; bundle install"	  	
end

task :compile_assets, :roles => :web do	  	
  run "cd #{deploy_to}/current/; bundle exec rake assets:precompile"  	
end

task :mongoid_create_indexes, :roles => :web do
  run "cd #{deploy_to}/current/; bundle exec rake db:mongoid:create_indexes"
end

after "deploy:finalize_update","deploy:symlink", :init_shared_path, :link_shared_files, :install_gems, :compile_assets, :mongoid_create_indexes


set :default_environment, {
  'PATH' => "/home/lyl/.rvm/gems/ruby-1.9.2-p290/bin:/home/lyl/.rvm/gems/ruby-1.9.2-p290@global/bin:/home/lyl/.rvm/rubies/ruby-1.9.2-p290/bin:/home/lyl/.rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
  'RUBY_VERSION' => 'ruby-1.9.2-p290',
  'GEM_HOME' => '/home/lyl/.rvm/gems/ruby-1.9.2-p290',
  'GEM_PATH' => '/home/lyl/.rvm/gems/ruby-1.9.2-p290:/home/lyl/.rvm/gems/ruby-1.9.2-p290@global'
}
