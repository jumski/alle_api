require 'spec_helper'
require 'rspec/allegro'
require 'rspec/sidekiq_examples'

describe AlleApi::Job::UpdateCategoriesTree do
  it { should be_a AlleApi::Job::Base }
  it_is_an 'unique job', 4.hours

  include_examples 'initializes and calls a helper' do
    let(:helper_klass) { AlleApi::Helper::CategoryTreeSynchronizer }
    let(:helper_method) { :synchronize! }
    let(:constructor_args) { [ fake_api ] }
  end
end
