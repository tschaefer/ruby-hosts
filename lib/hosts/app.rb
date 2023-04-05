# frozen_string_literal: true

require_relative 'app/base'
require_relative 'app/add'
require_relative 'app/list'
require_relative 'app/remove'
require_relative 'app/set'

module Hosts
  module App
    class Command < Hosts::App::BaseCommand # rubocop:disable Style/Documentation
      subcommand 'add', 'add new hosts entry', Hosts::App::AddCommand
      subcommand 'add-alias', 'add list of aliases to hosts entry', Hosts::App::AddAliasCommand
      subcommand 'list', 'list all hosts entries', Hosts::App::ListCommand
      subcommand 'remove', 'remove hosts entry', Hosts::App::RemoveCommand
      subcommand 'remove-alias', 'remove list of aliases from hosts entry', Hosts::App::RemoveAliasCommand
      subcommand 'set-hostname', 'set hostname of hosts entry', Hosts::App::SetCommand
    end
  end
end
