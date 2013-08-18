require 'spec_helper'
require 'rspec/sidekiq_examples'

describe AlleApi::Job::UpdateComponents do
  it { should be_a AlleApi::Job::Base }
  it_is_an 'unique job', 24.hours

  include_examples 'initializes and calls a helper' do
    let(:helper_klass) { AlleApi::Helper::ComponentsUpdater }
    let(:helper_method) { :update! }
    let(:constructor_args) { [] }
  end
end
