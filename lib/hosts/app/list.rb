# frozen_string_literal: true

require 'tty-pager'
require 'tty-screen'

require_relative 'base'

module Hosts
  module App
    class ListCommand < Hosts::App::BaseCommand
      option '--[no-]legend', :flag, 'do not print a legend.', default: true
      option '--[no-]pager', :flag, 'do not pipe output into a pager.', default: true

      def execute
        hosts = hosts()

        legend = legend? ? "\n\n#{hosts.size} entries listed.\n" : "\n"
        table = hosts.to_table
        content = "#{table}#{legend}"

        pager(content)
      end

      private

      def pager(content)
        enabled = pager?

        if pager? &&
           (content.lines.size <= TTY::Screen.height &&
            content.lines.map(&:size).max <= TTY::Screen.width)
          enabled = false
        end

        TTY::Pager.new(enabled:).page(content)
      end
    end
  end
end
