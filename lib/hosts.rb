# frozen_string_literal: true

require_relative 'hosts/entry'
require_relative 'hosts/file'
require_relative 'hosts/remote'
require_relative 'hosts/table'

##
# Query and change system hosts file.
#
# * list entries
# * add entry
# * remove entry
# * set hostname, add or remove hostname aliases of existing entry
#
# All methods throw an exception on argument failure.
#
# * attribute validation
# * missing or already existing entry
# * read, write permission
#
# For further information see *man* *5* *hosts*.
#
# The method *parse* initialize an *Hosts* instance, all further method can
# also be called directly.
#
#   hosts = Hosts.parse
#   puts hosts.to_table
#
#   ADDRESS   HOSTNAME        ALIASES
#   ──────────────────────────────────────
#   127.0.0.1 localhost
#   ...
module Hosts
  class << self
    # :nodoc:
    include Hosts::File
    include Hosts::Table
    include Hosts::Remote
    # :doc:

    ##
    # Parses optional given hosts file (default system hosts file), create
    # entries list and return object.
    def parse(file: '/etc/hosts', remote: nil)
      @file = file
      @remote = remote
      @tempfile = nil
      @entries = {}

      remote_parse

      path = @tempfile || @file
      raise ArgumentError, "No such file: #{path}" if !CoreFile.exist?(path)

      parse_file(path).each do |entry|
        (address, hostname, aliases) = entry

        entry = Hosts::Entry.new(address, hostname, aliases || [])
        raise ArgumentError, "Duplicated entry: #{address}" if @entries.key?(address)

        @entries[address] = entry
      end
      self
    end

    ##
    # Adds hosts entry defined by following attributes.
    #
    # * IPv6 / IPv4 address
    # * hostname
    # * list of aliases (optional)
    def add(address, hostname, aliases = [])
      entries = entries()
      raise ArgumentError, 'Entry exists.' if entries.key?(address)

      entries[address] = Hosts::Entry.new(address, hostname, aliases)
      @entries = entries
      save
    end

    ##
    # Adds single or list of hostname aliases to existing entry.
    def add_alias(address, aliases)
      entries = entries()
      raise ArgumentError, 'No such entry.' if !entries.key?(address)

      entries[address].add_alias(aliases)
      @entries = entries
      save
    end

    # :nodoc:
    def entries
      return @entries if !@entries.nil?

      hosts = Hosts.parse
      hosts.entries
    end
    # :doc:

    ##
    # Returns list of entries sorted by address.
    def list
      entries.sort.to_h.values
    end

    ##
    # Removes entry by address.
    def remove(address)
      entries = entries()
      raise ArgumentError, 'No such entry.' if !entries.key?(address)

      entries.delete(address)
      @entries = entries
      save
    end

    ##
    # Removes single or list of hostname aliases of existing entry.
    def remove_alias(address, aliases)
      entries = entries()
      raise ArgumentError, 'No such entry.' if !entries.key?(address)

      entries[address].remove_alias(aliases)
      @entries = entries
      save
    end

    ##
    # Sets canonical hostname of existing entry.
    def set_hostname(address, hostname)
      entries = entries()
      raise ArgumentError, 'No such entry.' if !entries.key?(address)

      entries[address].set_hostname(hostname)
      @entries = entries
      save
    end

    ##
    # Returns count of current entries.
    def size
      entries.size
    end

    ##
    # Returns pretty formated table of entries with columns address, hostname
    # and aliases.
    def to_table
      render_table(list, pretty: true)
    end

    private

    def save
      return remote_save if !@remote.nil?

      write_file(@file, render_table(list))
    end
  end
end
