# frozen_string_literal: true

require 'spec_helper'

require 'hosts/entry'
require 'hosts/table'

RSpec.describe Hosts::Table do
  subject(:table) { described_class.new }

  let(:described_class) { Class.new { include Hosts::Table } }
  let(:entries) { [Hosts::Entry.new('127.0.0.1', 'localhost')] }

  describe '#render_table' do
    context 'with hosts entries' do
      it 'returns simple table' do
        expect(table.send(:render_table, entries)).to eq('127.0.0.1 localhost')
      end
    end

    context 'with hosts entries and pretty' do
      it 'returns table with header' do
        expect(table.send(:render_table, entries, pretty: true))
          .to eq("ADDRESS   HOSTNAME  ALIASES\n───────────────────────────\n127.0.0.1 localhost")
      end
    end

    context 'with no hosts entries' do
      it 'returns empty string' do
        expect(table.send(:render_table, [])).to eql('')
      end
    end
  end
end
