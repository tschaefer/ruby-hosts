# hostsctl

**hostsctl** - Query and control the system hosts file.

## Introduction

**hostsctl** may be used to query and change the system hosts file entries,
local and remote.

* list entries
* add new entry
* remove entry
* set hostname of existing entry
* add and remove alias of existing entry

## Installation

    $ gem build
    $ gem install -g
    $ gem install hosts-$(ruby -Ilib -e 'require "hosts/version"; puts Hosts::VERSION').gem

## Usage

For usage of command line tool `hostsctl` see following help output.

    Usage:
        hostsctl [OPTIONS] SUBCOMMAND [ARG] ...

    Parameters:
        SUBCOMMAND         subcommand
        [ARG] ...          subcommand arguments

    Subcommands:
        add                add new hosts entry
        add-alias          add list of aliases to hosts entry
        list               list all hosts entries
        remove             remove hosts entry
        remove-alias       remove list of aliases from hosts entry
        set-hostname       set hostname of hosts entry

    Options:
        -h, --help                print help
        -m, --man                 show manpage
        -v, --version             show version
        -f, --file FILE           hosts file (default: system file)
        -H, --host [USER@]HOST    operate on remote host

For API documentation use `rake doc`.

## License

[MIT License](https://spdx.org/licenses/MIT.html).

## Is it any good?

[Yes](https://news.ycombinator.com/item?id=3067434)
