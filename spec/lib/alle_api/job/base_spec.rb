# encoding: utf-8

require 'spec_helper'

describe AlleApi::Job::Base do
  subject { Class.new(described_class).new }

  include_context 'silenced logger'

  it { should be_a Sidekiq::Worker }

  describe '.sidekiq_options' do
    subject { described_class.sidekiq_options }

    it 'includes backtrace' do
      expect(subject['backtrace']).to be_true
    end

    it 'uses default retry scheme' do
      expect(subject['retry']).to be_true
    end

    it 'uses alle_api queue' do
      expect(subject['queue']).to eq(:alle_api)
    end
  end
end
