require 'spec_helper'

describe AlleApi::Job::ConsiderRepublication do
  include_context 'silenced logger'

  subject { described_class.new }
  let(:auction_template) { create :template }

  before do
    AlleApi::AuctionTemplate.expects(:find).with(auction_template.id).returns(auction_template)
  end

  context "#perform" do
    context 'when #publishing_enabled? is true' do
      before { subject.stubs(publishing_enabled?: true)}

      it 'calls publish_next_auction' do
        auction_template.expects(:publish_next_auction)

        subject.perform(auction_template.id)
      end
    end

    context 'when #publishing_enabled? is false' do
      before { auction_template.stubs(publishing_enabled?: false)}

      it 'does not call publish_next_auction' do
        auction_template.expects(:publish_next_auction).never

        subject.perform(auction_template.id)
      end
    end
  end
end
