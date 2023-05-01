# frozen_string_literal: true

require 'spec_helper'

require 'hosts/validate'

RSpec.describe Hosts::Validator do
  subject(:validator) { described_class.new }

  let(:described_class) { Class.new { include Hosts::Validator } }

  describe '#assert_address' do
    it 'raises no exception on valid IPv4' do
      expect { validator.assert_address('127.0.0.1') }.not_to raise_error
    end

    it 'raises no exception on valid IPv6' do
      expect { validator.assert_address('::1') }.not_to raise_error
    end

    it 'raises exception on invalid IP' do
      expect { validator.assert_address('bad') }.to raise_error(/Invalid address/)
    end
  end

  describe '#assert_hostname' do
    it 'raises no exception on valid hostname' do
      expect { validator.assert_hostname('localhost') }.not_to raise_error
    end

    it 'raises exception on too short hostname' do
      expect { validator.assert_hostname('lo') }.not_to raise_error
    end

    it 'raises exception on invalid hostname' do
      expect { validator.assert_hostname('löcälhöst') }.to raise_error(/Invalid hostname/)
    end
  end

  describe '#assert_aliases' do
    it 'raises no exception on valid hostname' do
      expect { validator.assert_aliases(%w[localhost localhost.localdomain]) }.not_to raise_error
    end

    it 'raises exception on too short hostname' do
      expect { validator.assert_aliases(%w[localhost lo]) }.not_to raise_error
    end

    it 'raises exception on invalid hostname' do
      expect { validator.assert_aliases(%w[löcälhöst]) }.to raise_error(/Invalid alias/)
    end
  end
end
