# frozen_string_literal: true

module Hosts
  module File # rubocop:disable Style/Documentation
    private

    def parse_file(file)
      entries = []
      ::File.foreach(file) do |line|
        next if line.match(/^\s*$/) || line.start_with?(/\s*#/)

        (address, hostname, aliases) = line.split(nil, 3)
        aliases = aliases.empty? || aliases.start_with?('#') ? [] : aliases.split
        index = aliases.index do |entry|
          entry.start_with?('#')
        end
        aliases = aliases.take(index) if index

        entries << [address, hostname, aliases]
      end
      entries
    end

    def write_file(file, body)
      content = "#{@legend}\n\n#{body}\n"

      ::File.write(file, content)
    end
  end
end
