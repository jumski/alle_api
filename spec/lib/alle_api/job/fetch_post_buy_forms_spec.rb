require 'spec_helper'
require 'rspec/allegro'
require 'rspec/freezed_time_context'
require 'rspec/sidekiq_examples'

describe AlleApi::Job::FetchPostBuyForms do
  include_context 'with account'
  include_context 'silenced logger'
  include_context 'freezed time'

  subject { described_class.new }

  it_is_an 'unique job', 24.hours

  it { should be_a AlleApi::Job::Base }

  before do
    AlleApi::Account.any_instance.stubs(missing_transaction_ids: [1,2,3])
  end

  it 'calls api once if less than 25 ids' do
    api.expects(:get_post_buy_forms_for_sellers).with([1,2,3]).returns([])

    subject.perform(account.id)
  end

  it 'calls api twice if more than 25 ids' do
    ids = (1..26).to_a
    AlleApi::Account.any_instance.stubs(missing_transaction_ids: ids)

    ids.each_slice(25) do |slice|
      api.expects(:get_post_buy_forms_for_sellers).with(slice).returns([])
    end

    subject.perform(account.id)
  end

  it 'calls #create_if_missing on all returned wrappers' do
    wrapper1, wrapper2 = mock, mock
    wrapper1.expects(:create_if_missing)
    wrapper2.expects(:create_if_missing)
    api.stubs(get_post_buy_forms_for_sellers: [wrapper1, wrapper2])

    subject.perform(account.id)
  end

  it 'does not call api when no transaction ids' do
    AlleApi::Account.any_instance.stubs(missing_transaction_ids: [])
    api.expects(:get_post_buy_forms_for_sellers).never

    subject.perform(account.id)
  end
end
