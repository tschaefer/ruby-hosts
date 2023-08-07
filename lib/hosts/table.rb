# frozen_string_literal: true

require 'tty-table'

module Hosts
  module Table # rubocop:disable Style/Documentation
    private

    def render_table(entries, pretty: false) # rubocop:disable Metrics/AbcSize
      seperator = pretty ? "\n" : ' '

      rows = entries.map do |entry|
        [entry.address, entry.hostname, entry.aliases.empty? ? '' : entry.aliases.join(seperator)]
      end

      header = pretty ? %w[ADDRESS HOSTNAME ALIASES] : nil
      table = TTY::Table.new(header:, rows:)

      rendered = if pretty
                   table.render(multiline: true, width: 2**16) do |renderer|
                     renderer.border do
                       mid     '─'
                       mid_mid '─'
                       center  ' '
                     end
                   end
                 else
                   table.render(:basic, width: 2**16)
                 end

      rendered.nil? ? '' : rendered.gsub(/\s+$/, '')
    end
  end
end
