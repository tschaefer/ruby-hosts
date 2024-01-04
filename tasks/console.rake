# frozen_string_literal: true

ROOT_DIR = File.expand_path('..', __dir__)
$LOAD_PATH.unshift "#{ROOT_DIR}/lib"

def silent
  original_stdout = $stdout.clone
  original_stderr = $stderr.clone
  $stderr.reopen File.new(File::NULL, 'w')
  $stdout.reopen File.new(File::NULL, 'w')
  yield
ensure
  $stdout.reopen original_stdout
  $stderr.reopen original_stderr
end

def reload!(print: true)
  puts 'Reloading...' if print
  reload_dirs = %w[lib]
  reload_dirs.each do |dir|
    Dir.glob("#{ROOT_DIR}/#{dir}/**/*.rb").each { |f| silent { load(f) } }
  end

  true
end

desc 'Start a console session with Hosts loaded'
task :console do
  require 'pry'
  require 'pry-byebug'
  require 'pry-doc'
  require 'hosts'

  ARGV.clear

  Pry.start
end
