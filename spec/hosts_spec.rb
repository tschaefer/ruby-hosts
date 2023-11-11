# frozen_string_literal: true

require 'spec_helper'

require 'fileutils'
require 'tempfile'

require 'hosts'

RSpec.describe Hosts do
  let(:assert) { "#{File.dirname(__FILE__)}/data/hosts" }
  let(:file) { Tempfile.new }

  around do |example|
    FileUtils.cp(assert, file.path)
    example.run
    FileUtils.rm_f(file.path)
  end

  describe '#parse' do
    context 'when file is not existing' do
      it 'raises an error' do
        expect { described_class.parse(file: '/no/such/file') }.to raise_error(/No such file/)
      end
    end

    context 'when file is existing' do
      it 'returns an object', :aggregate_failures do
        hosts = described_class.parse(file: file.path)

        methods = %i[
          add
          add_alias
          entries
          list
          remove
          remove_alias
          set_hostname
          to_table
        ]
        expect(hosts.public_methods(false)).to include(*methods)
        expect(hosts.size).to be(7)
      end
    end
  end

  describe '#list' do
    it 'returns a host entries list ordered by address', :aggregate_failures do
      list = described_class.parse(file: file.path).list

      expect(list).to be_an(Array)
      expect(list).to all(be_a(Hosts::Entry))
      expect(list.size).to be(7)
      expect(list.map(&:address)).to eq(
        [
          '127.0.0.1',
          '127.0.1.1',
          '::1',
          'fe00::0',
          'ff00::0',
          'ff02::1',
          'ff02::2'
        ]
      )
    end
  end

  describe '#add' do
    it 'creates a new host entry' do
      hosts = described_class.parse(file: file.path)
      hosts.add('10.0.0.1', 'gateway')

      expect(hosts.entries.key?('10.0.0.1')).to be true
    end

    it 'raises an error when host entry already exists' do
      hosts = described_class.parse(file: file.path)

      expect { hosts.add('127.0.0.1', 'localhost') }
        .to raise_error(ArgumentError, 'Entry exists.')
    end
  end

  describe '#remove' do
    it 'deletes an host entry' do
      hosts = described_class.parse(file: file.path)
      hosts.remove('127.0.1.1')

      expect(hosts.entries.key?('127.0.1.1')).to be false
    end

    it 'raises an error when host entry is not existing' do
      hosts = described_class.parse(file: file.path)

      expect { hosts.remove('10.0.0.1') }
        .to raise_error(ArgumentError, 'No such entry.')
    end
  end

  describe '#add_alias' do
    it 'inserts new aliases' do
      hosts = described_class.parse(file: file.path)
      hosts.add_alias('127.0.1.1', ['home'])

      entry = hosts.entries['127.0.1.1']
      expect(entry.aliases).to include('home')
    end

    it 'raises an error when host entry is not existing' do
      hosts = described_class.parse(file: file.path)

      expect { hosts.add_alias('10.0.0.1', ['router']) }
        .to raise_error(ArgumentError, 'No such entry.')
    end
  end

  describe '#remove_alias' do
    it 'deletes aliases', :aggregate_failures do
      hosts = described_class.parse(file: file.path)
      hosts.remove_alias('127.0.1.1', ['hostname'])

      entry = hosts.entries['127.0.1.1']
      expect(entry.aliases).not_to include('hostname')
      expect(entry.aliases).to be_empty
    end

    it 'raises an error when host entry is not existing' do
      hosts = described_class.parse(file: file.path)

      expect { hosts.remove_alias('10.0.0.1', ['router']) }
        .to raise_error(ArgumentError, 'No such entry.')
    end
  end

  describe '#set_hostname' do
    it 'modifies hostname' do
      hosts = described_class.parse(file: file.path)
      hosts.set_hostname('127.0.1.1', 'localhost.localdomain')

      entry = hosts.entries['127.0.1.1']
      expect(entry.hostname).to match('localhost.localdomain')
    end

    it 'raises an error when host entry is not existing' do
      hosts = described_class.parse(file: file.path)

      expect { hosts.set_hostname('10.0.0.1', 'router') }
        .to raise_error(ArgumentError, 'No such entry.')
    end
  end

  describe '#to_table' do
    it 'returns pretty table with hosts entries', :aggregate_failures do
      hosts = described_class.parse(file: file.path)

      expect(hosts.to_table).to match(/ADDRESS\s+HOSTNAME\s+ALIASES/)
      expect(hosts.to_table).to match(/::1\s+ip6-localhost\s+ip6-loopback/)
    end
  end
end
