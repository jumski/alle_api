require 'spec_helper'
require 'rspec/allegro'
require 'rspec/freezed_time_context'
require 'rspec/sidekiq_examples'

describe AlleApi::Job::FetchPostBuyForms do
  include_context 'with account'
  include_context 'silenced logger'
  include_context 'freezed time'

  subject { described_class.new }

  it_is_an 'unique job', 10.minutes

  it { should be_a AlleApi::Job::Base }

  # before do
  #   @de1 = create :fresh_new_transaction, remote_transaction_id: 7, account: account
  #   @de2 = create :fresh_new_transaction, remote_transaction_id: 8, account: account
  #   @de3 = create :new_transaction, account: account
  #   @de4 = create :fresh_new_transaction, remote_transaction_id: 9, auctions: (create(:auction, account: create(:account)))
  # end
  # let(:tids) { [@de1.remote_transaction_id, @de2.remote_transaction_id] }
  before do
    AlleApi::Account.any_instance.stubs(missing_transaction_ids: [1,2,3])
  end

  it 'gets new forms from the api' do
    api.expects(:get_post_buy_forms_for_sellers).with([1,2,3]).returns([])

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
