# Rakefile

require_relative 'config/application'

Rails.application.load_tasks

# Prevent Rails from running asset tasks in API-only apps
Rake::Task['assets:precompile'].clear if Rake::Task.task_defined?('assets:precompile')

Rake::Task['assets:clean'].clear if Rake::Task.task_defined?('assets:clean')
