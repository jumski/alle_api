require 'spec_helper'
require 'rspec/allegro'
require 'rspec/freezed_time_context'
require 'rspec/sidekiq_examples'

describe AlleApi::Job::FetchDealsEvents do
  include_context 'with account'
  include_context 'stubbed get_journal events'
  include_context 'silenced logger'
  include_context 'freezed time'

  subject { described_class.new }

  it_is_an 'unique job', 10.minutes

  it { should be_a AlleApi::Job::Base }

  it 'calls api.get_deals_journal' do
    api.expects(:get_deals_journal).returns([])

    expect(subject.perform(account.id)).to eq []
  end

  it 'creates new AuctionEvent for each returned event' do
    event_a, event_b = mock('event a'), mock('event b')
    api.stubs(get_deals_journal: [event_a, event_b])

    event_a.expects(:create_deal_event)
    event_b.expects(:create_deal_event)

    subject.perform(account.id)
  end

#   it 'enqueues TriggerAuctionEvents' do
#     api.stubs(get_journal: [])
#     subject.perform(account.id)
#
#     expect(AlleApi::Job::TriggerAuctionEvents).to \
#       have_queued_job_at(time_now + 5.seconds, account.id)
#   end
end
