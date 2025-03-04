# frozen_string_literal: true

require 'rake/testtask'
require 'rubocop/rake_task'
require 'yard'

RuboCop::RakeTask.new

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
end
