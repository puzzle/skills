# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require 'rake'
require 'rake/testtask'

Rails.application.load_tasks

Rake::TestTask.new(:test) do |t|
  t.libs << ['lib', 'test']
  t.test_files = Dir['test/**/*_test.rb'].reject do |path|
    path.include?['features']
  end
  t.warning = false
end
