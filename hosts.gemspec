# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'hosts/version'

Gem::Specification.new do |spec|
  spec.name        = 'hosts'
  spec.version     = Hosts::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ['Tobias Schäfer']
  spec.email       = ['github@blackox.org']

  spec.summary     = 'Query and control the system hosts file.'
  spec.description = <<~DESC
    #{spec.summary}

      * list entries
      * add, remove entries
      * add, remove entry aliases
      * set entry hostname
  DESC
  spec.homepage = 'https://github.com/tschaefer/ruby-hosts'
  spec.license  = 'MIT'

  spec.files                 = Dir['lib/**/*']
  spec.bindir                = 'bin'
  spec.executables           = ['hostsctl']
  spec.require_paths         = ['lib']
  spec.required_ruby_version = '>= 3.1'

  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata['source_code_uri']       = 'https://github.com/tschaefer/ruby-hosts'
  spec.metadata['bug_tracker_uri']       = 'https://github.com/tschaefer/ruby-hosts/issues'
end
