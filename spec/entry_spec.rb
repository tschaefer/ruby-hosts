# frozen_string_literal: true

require 'spec_helper'

require 'hosts/entry'

RSpec.describe Hosts::Entry do
  let!(:entry) { described_class.new('127.0.0.1', 'localhost', ['localhost.localdomain']) }

  describe '#new' do
    context 'with bad arguments' do
      it 'raises an error' do
        expect { described_class.new('bad', 'localhost') }
          .to raise_error(ArgumentError, /Invalid address/)
        expect { described_class.new('127.0.0.1', 'löcälhöst') }
          .to raise_error(ArgumentError, /Invalid hostname/)
        expect { described_class.new('127.0.0.1', 'localhost', ['löcälhöst.löcäldömäin']) }
          .to raise_error(ArgumentError, /Invalid alias/)
      end
    end

    context 'with valid arguments' do
      it 'succeeds' do
        expect(described_class.new('127.0.0.1', 'localhost'))
          .to be_an(described_class)
        expect(described_class.new('127.0.0.1', 'localhost', ['localhost.localdomain']))
          .to be_an(described_class)
      end
    end
  end

  describe '#add_alias' do
    context 'with bad argument' do
      it 'raises an error' do
        expect { entry.add_alias('löcälhöst.fqdn.example.cöm') }
          .to raise_error(ArgumentError, /Invalid alias/)
      end
    end

    context 'with valid argument' do
      it 'succeeds' do
        entry.add_alias('localhost.fqdn.example.com')

        expect(entry.aliases).to match_array(
          ['localhost.localdomain', 'localhost.fqdn.example.com']
        )
      end
    end
  end

  describe '#remove_alias' do
    context 'with bad argument' do
      it 'raises an error' do
        expect { entry.remove_alias('löcälhöst.löcäldömäin') }
          .to raise_error(ArgumentError, /Invalid alias/)
      end
    end

    context 'with valid argument' do
      it 'succeeds' do
        entry.remove_alias('localhost.localdomain')

        expect(entry.aliases).to be_empty
      end
    end
  end

  describe '#set_hostname' do
    context 'with bad argument' do
      it 'raises an error' do
        expect { entry.set_hostname('höme') }
          .to raise_error(ArgumentError, /Invalid hostname/)
      end
    end

    context 'with valid argument' do
      it 'succeeds' do
        entry.set_hostname('home')

        expect(entry.hostname).to eql('home')
      end
    end
  end

  describe 'set_address' do
    context 'with bad argument' do
      it 'raises an error' do
        expect { entry.set_address('333.333.333.333') }
          .to raise_error(ArgumentError, /Invalid address/)
      end
    end

    context 'with valid argument' do
      it 'succeeds' do
        entry.set_address('127.0.1.1')

        expect(entry.address).to eql('127.0.1.1')
      end
    end
  end

  describe 'private: #mangle_alias' do
    it 'returns an uniq array' do
      array = entry.send(:mangle_alias, %w[home home place place localhost])

      expect(array & array == array).to be true # rubocop:disable Lint
    end

    it 'ignores alias equal to hostname' do
      expect(entry.send(:mangle_alias, entry.hostname)).not_to include(entry.hostname)
    end
  end
end
