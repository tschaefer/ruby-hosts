# frozen_string_literal: true

require_relative 'base'

module Hosts
  module App
    class SetCommand < Hosts::App::BaseCommand
      parameter 'ADDRESS', 'IPv4 / IPv6 address'
      parameter 'HOSTNAME', 'canonical hostname'

      def execute
        hosts.set_hostname(address, hostname)
      rescue StandardError => e
        bailout(e)
      end
    end
  end
end
