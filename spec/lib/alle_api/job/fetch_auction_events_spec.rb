require 'spec_helper'
require 'rspec/allegro'
require 'rspec/freezed_time_context'
require 'rspec/sidekiq_examples'

describe AlleApi::Job::FetchAuctionEvents do
  include_context 'with account'
  include_context 'stubbed get_journal events'
  include_context 'silenced logger'
  include_context 'freezed time'

  subject { described_class.new }

  it_is_an 'unique job', 24.hours

  it_behaves_like 'a job for each account'

  before do
    AlleApi::Account.any_instance.
      stubs(last_auction_event_remote_id: 66)
  end

  it 'calls api.get_journal with last remote_id + 1' do
    api.expects(:get_journal).with(67).returns([])

    subject.perform(account.id)
  end

  it 'calls api.get_journal with custom remote_id if passed' do
    api.expects(:get_journal).with(99).returns([])

    subject.perform(account.id, 99)
  end

  it 'creates new AuctionEvent for each returned event' do
    event_a, event_b = mock('event a'), mock('event b')
    api.stubs(get_journal: [event_a, event_b])

    event_a.expects(:create_auction_event).with(account)
    event_b.expects(:create_auction_event).with(account)

    subject.perform(account.id)
  end

  it 'enqueues TriggerAuctionEvents' do
    api.stubs(get_journal: [])
    subject.perform(account.id)

    expect(AlleApi::Job::TriggerAuctionEvents).to \
      have_queued_job_at(time_now + 5.seconds, account.id)
  end
end
