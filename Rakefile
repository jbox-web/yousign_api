# frozen_string_literal: true

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task default: :spec

task :console do
  require 'pry'
  require 'yousign-api'
  ARGV.clear
  Pry.start
end
