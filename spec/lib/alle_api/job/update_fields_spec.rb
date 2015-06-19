require 'spec_helper'
require 'rspec/sidekiq_examples'

describe AlleApi::Job::UpdateFields do
  it { should be_a AlleApi::Job::Base }
  it_is_an 'unique job', 30.minutes

  include_examples 'initializes and calls a helper' do
    let(:helper_klass) { AlleApi::Helper::FieldsSynchronizer }
    let(:helper_method) { :synchronize! }
    let(:constructor_args) { [ fake_api ] }
  end
end
