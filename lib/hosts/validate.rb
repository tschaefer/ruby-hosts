# frozen_string_literal: true

require 'resolv'

module Hosts
  module Validator # rubocop:disable Style/Documentation
    private

    HOSTNAME = /
      (?=^.{2,253}$)
      (?:^(?:(?!-)[a-zA-Z0-9-]{0,62}[a-zA-Z0-9]\.?)+[a-zA-Z0-9]{1,63}$)
    /x

    def assert_address(address)
      return if address.match(/#{Resolv::IPv4::Regex}|#{Resolv::IPv6::Regex}/)

      raise ArgumentError, "Invalid address: #{address}"
    end

    def assert_aliases(aliases)
      aliases.each do |hostname|
        next if hostname.match(HOSTNAME)

        raise ArgumentError, "Invalid alias: #{hostname}"
      end
    end

    def assert_hostname(hostname)
      return if hostname.match(HOSTNAME)

      raise ArgumentError, "Invalid hostname: #{hostname}"
    end
  end
end
