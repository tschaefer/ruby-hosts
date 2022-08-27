# frozen_string_literal: true

require_relative 'base'

module Hosts
  module App
    class RemoveCommand < Hosts::App::BaseCommand
      parameter 'ADDRESS', 'IPv4 / IPv6 address'

      def execute
        hosts.remove(address)
      rescue StandardError => e
        bailout(e)
      end
    end

    class RemoveAliasCommand < Hosts::App::BaseCommand
      parameter 'ADDRESS', 'IPv4 / IPv6 address'
      parameter 'ALIASES ...', 'list of aliases', attribute_name: :aliases

      def execute
        hosts.remove_alias(address, aliases)
      rescue StandardError => e
        bailout(e)
      end
    end
  end
end
