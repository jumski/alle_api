require 'spec_helper'
require 'rspec/allegro'
require 'rspec/freezed_time_context'
require 'rspec/sidekiq_examples'

describe AlleApi::Job::FetchDealEvents do
  include_context 'with account'
  include_context 'stubbed get_journal events'
  include_context 'silenced logger'
  include_context 'freezed time'

  subject { described_class.new }

  it_is_an 'unique job', 10.minutes

  it { should be_a AlleApi::Job::Base }

  before do
    AlleApi::Account.any_instance.
      stubs(last_deal_event_remote_id: 77)
  end

  it 'calls api.get_deals_journal with last remote id + 1' do
    api.expects(:get_deals_journal).with(78).returns([])

    expect(subject.perform(account.id)).to eq []
  end

  it 'creates new AuctionEvent for each returned event' do
    event_a, event_b = mock('event a'), mock('event b')
    api.stubs(get_deals_journal: [event_a, event_b])

    event_a.expects(:create_if_missing)
    event_b.expects(:create_if_missing)

    subject.perform(account.id)
  end
end
