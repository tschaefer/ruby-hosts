# frozen_string_literal: true

require_relative 'base'

module Hosts
  module App
    class AddCommand < Hosts::App::BaseCommand
      parameter 'ADDRESS', 'IPv4 / IPv6 address'
      parameter 'HOSTNAME', 'canonical hostname'
      parameter '[ALIASES ...]', 'optional list of aliases', attribute_name: :aliases

      def execute
        hosts.add(address, hostname, aliases || [])
      rescue StandardError => e
        bailout(e)
      end
    end

    class AddAliasCommand < Hosts::App::BaseCommand
      parameter 'ADDRESS', 'IPv4 / IPv6 address'
      parameter 'ALIASES ...', 'list of aliases', attribute_name: :aliases

      def execute
        hosts.add_alias(address, aliases)
      rescue StandardError => e
        bailout(e)
      end
    end
  end
end
