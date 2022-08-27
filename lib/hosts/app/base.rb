# frozen_string_literal: true

require 'clamp'
require 'pastel'
require 'tty-pager'

require_relative '../version'
require_relative '../../hosts'

module Hosts
  module App
    class BaseCommand < Clamp::Command
      option ['-m', '--man'], :flag, 'show manpage' do
        manpage = <<~MANPAGE
          Name:
              hostsctl - Query and control the system hosts file.

          #{help}
          Description:
              hostsctl may be used to query and change the system hosts file ("man 5 hosts").

          Authors:
              Tobias Schäfer <github@blackox.org>

          Copyright and License
              This software is copyright (c) 2022 by Tobias Schäfer.

              This package is free software; you can redistribute it and/or modify it under the terms of the "MIT License".
        MANPAGE
        TTY::Pager.page(manpage)

        exit 0
      end

      option ['-v', '--version'], :flag, 'show version' do
        puts "hostsctl #{Hosts::VERSION}"
        exit(0)
      end

      option ['-f', '--file'], 'FILE', 'hosts file (default: system file)'

      def hosts
        Hosts.parse(file)
      rescue StandardError => e
        bailout(e)
      end

      def bailout(error)
        puts Pastel.new.red.bold(error.cause || error.message)
        exit(1)
      end
    end
  end
end
