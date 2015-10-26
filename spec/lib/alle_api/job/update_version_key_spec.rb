require 'spec_helper'
require 'rspec/sidekiq_examples'

describe AlleApi::Job::UpdateVersionKey do
  it { should be_a AlleApi::Job::Base }
  it_is_an 'unique job', 15.seconds

  it '#perform triggers version update via Versions helper' do
    versions = stub
    AlleApi::Helper::Versions.expects(:new).returns(versions)
    versions.expects(:update).with(:version_key)

    AlleApi::Job::UpdateVersionKey.new.perform
  end
end

