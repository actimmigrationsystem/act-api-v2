# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks
# Prevent Rails from running asset tasks in API-only apps
Rake::Task['assets:precompile'].clear if Rake::Task.task_defined?('assets:precompile')
Rake::Task['assets:clean'].clear if Rake::Task.task_defined?('assets:clean')
