require 'spec_helper'

describe AlleApi do
  subject { described_class }

  it '#redis should be a redis namespace' do
    expect(subject.redis).to be_a Redis::Namespace
    expect(subject.redis.namespace).to eq('AlleApi')
    expect(subject.redis.redis).to eq(Redis.current)
  end

  describe 'AlleApi.config' do
    it 'returns AlleApi::Config for current PROJECT_ENV' do
      AlleApi.config.should == AlleApi::Config[Rails.env]
    end
  end

  describe 'AlleApi.utility_api' do
    it 'gets api from utility account' do
      fake_api = stub('Api')
      fake_account = stub('Account', api: fake_api)
      AlleApi::Account.stubs(utility: fake_account)

      expect(AlleApi.utility_api).to eq(fake_api)
    end
  end

  describe '.versions' do
    it 'instantiates Versions object' do
      AlleApi::Helper::Versions.expects(:new).returns('versions')

      expect(AlleApi.versions).to eq("versions")
    end

    it 'always returns new instance' do
      expect(AlleApi.versions).to_not eq(AlleApi.versions)
    end
  end

end
