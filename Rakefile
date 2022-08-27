# frozen_string_literal: true

$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib"

desc 'Build documentation.'
task :doc do
  system 'rdoc lib/hosts.rb lib/hosts/entries.rb'
end

desc 'Run rspec tests.'
task :test do
  system 'rspec'
end

desc 'Start a console session with Hosts loaded'
task :console do
  require 'irb'
  require 'irb/completion'
  require 'hosts'

  ARGV.clear
  IRB.start
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new

desc "Run tasks 'test' and 'rubocop' by default."
task default: %w[test rubocop]
