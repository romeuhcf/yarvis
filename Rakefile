# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks



if ENV['RAILS_ENV'] != 'production'
  desc 'Reset all database and redis - use with caution'
  task :reset => [:environment] do
    %w{ db:drop db:create db:migrate db:seed }.each do |t|
      Rake::Task[t].execute
    end
    system("redis-cli flushall")
  end 
end 
