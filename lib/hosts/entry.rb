# frozen_string_literal: true

require_relative 'validate'

module Hosts
  class Entry # rubocop:disable Style/Documentation
    include Hosts::Validator

    attr_reader :address, :hostname, :aliases

    def initialize(address, hostname, aliases = [])
      @aliases = []

      set_address(address)
      set_hostname(hostname)
      add_alias(aliases)
    end

    def add_alias(aliases)
      @aliases += mangle_alias(aliases)
      @aliases.uniq!
    end

    def remove_alias(aliases)
      @aliases -= mangle_alias(aliases)
    end

    def set_address(address) # rubocop:disable Naming/AccessorMethodName
      assert_address(address)

      @address = address
    end

    def set_hostname(hostname) # rubocop:disable Naming/AccessorMethodName
      assert_hostname(hostname)

      @hostname = hostname
    end

    private

    def mangle_alias(aliases)
      aliases = [aliases] if aliases.is_a?(String)
      assert_aliases(aliases)

      aliases.delete(hostname)
      aliases.uniq!

      aliases
    end
  end
end
