require 'spec_helper'
require 'rspec/allegro'
require 'rspec/sidekiq_examples'

describe AlleApi::Job::TriggerAuctionEvents do
  include_context 'with account'
  include_context 'silenced logger'

  subject { described_class.new }

  let(:auction) { build_stubbed :auction, :published }
  before do
    @events = create_list :auction_event_update, 2,
      :triggered, auction: auction, account: account
  end

  it_is_an 'unique job', 60.seconds

  it { should be_a AlleApi::Job::Base }

  it 'triggers every un-triggered event' do
    AlleApi::Account.any_instance.stubs(untriggered_events: @events)

    @events[0].expects(:trigger).once
    @events[1].expects(:trigger).once

    subject.perform(account.id)
  end
end
