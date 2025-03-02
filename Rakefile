# frozen_string_literal: true

require 'rake/testtask'
require 'bundler/gem_tasks' # Adds `rake build`, `rake install`, and `rake release`
require 'rubocop/rake_task'

RuboCop::RakeTask.new

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
end
