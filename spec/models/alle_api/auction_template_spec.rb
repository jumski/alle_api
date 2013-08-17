require 'spec_helper'
require 'shared/auction'

describe AlleApi::AuctionTemplate do
  subject { build_stubbed :template }
  let(:auctionable) { DummyAuctionable.create(title: 'omg') }

  it_behaves_like 'auction' do
    let(:factory) { :template }
  end

  it { should have_many(:auctions) }

  it 'should have shared attributes' do
    shared = AlleApi::AuctionTemplate::SHARED_ATTRIBUTES

    shared.should include 'title'
    shared.should include 'price'
    shared.should include 'auctionable_id'
    shared.should include 'auctionable_type'
    shared.should include 'additional_info'
    shared.should include 'economic_package_price'
    shared.should include 'economic_letter_price'
    shared.should include 'priority_package_price'
    shared.should include 'priority_letter_price'
  end

  its(:publishing_enabled) { should be_true }

  context 'when title is empty' do
    before do
      @template = build(:template)
      @template.title = nil
    end

    it 'steals title from auctionable when validated' do
      @template.auctionable = auctionable
      @template.valid?

      expect(@template.title).to eq(auctionable.title_for_auction)
    end

    it 'does not throw error if auctionable is not present' do
      expect { @template.valid? }.to_not raise_error
    end
  end

  context 'when title is present' do
    it 'does not change title when validated' do
      template = build(:template)
      template.auctionable = auctionable
      old_title = template.title
      template.valid?

      expect(template.title).to eq(old_title)
    end
  end

  describe '.create_from_auction' do
    let(:auction) { create :auction }
    subject { described_class.create_from_auction(auction) }

    it { should be_valid }

    it { should be_persisted }

    it 'returns template' do
      subject.should be_a described_class
    end

    # sets new template attributes based on auction attributes
    described_class::SHARED_ATTRIBUTES.each do |attribute|
      its(attribute) { should == auction.send(attribute) }
    end

    it 'adds auction to auctions' do
      subject.auctions.last.should == auction
    end

    it 'sets template in auction' do
      subject # kick off creation

      auction.template.should == subject
    end

    it 'steals account from auction' do
      expect(subject.account).to eq(auction.account)
    end

    it 'raises validation error if invalid' do
      described_class.any_instance.stubs(valid?: false)

      expect { subject }.to raise_error ActiveRecord::RecordInvalid
    end

  end

  describe '#consider_republication' do
    context 'when #publishing_enabled? is true' do
      before { subject.stubs(publishing_enabled?: true)}

      it 'calls publish_next_auction' do
        subject.expects(:publish_next_auction)

        subject.consider_republication
      end
    end

    context 'when #publishing_enabled? is false' do
      before { subject.stubs(publishing_enabled?: false)}

      it 'does not call publish_next_auction' do
        subject.expects(:publish_next_auction).never

        subject.consider_republication
      end

    end
  end

  describe '#publish_next_auction' do

    it 'creates new auction using spawn_auction' do
      new_auction = stub_everything('new auction')
      subject.expects(:spawn_auction).returns(new_auction)

      subject.publish_next_auction
    end

    it 'calls #publish! on newly spawned auction' do
      new_auction = mock()
      new_auction.expects(:queue_for_publication!)
      subject.stubs(:spawn_auction).returns(new_auction)

      subject.publish_next_auction
    end
  end

  describe '#spawn_auction' do
    let(:template) { create :template }
    subject { template.spawn_auction }

    it { should be_valid }
    it { should_not be_new_record }

    # sets new auction attributes based on template attributes
    described_class::SHARED_ATTRIBUTES.each do |attribute|
      its(attribute) { should == template.send(attribute) }
    end
  end

  describe '#disable_publishing!' do
    subject { create :template, publishing_enabled: true }

    specify do
      expect {
       subject.disable_publishing!
       subject.reload
      }.to change(subject, :publishing_enabled?).from(true).to(false)
    end

    it 'raises error if record invalid' do
      subject.stubs(valid?: false)

      expect {
        subject.disable_publishing!
      }.to raise_error ActiveRecord::RecordInvalid
    end
  end

  describe '#enable_publishing!' do
    subject { create :template, publishing_enabled: false }

    specify do
      expect {
       subject.enable_publishing!
       subject.reload
      }.to change(subject, :publishing_enabled?).from(false).to(true)
    end

    it 'raises error if record invalid' do
      subject.stubs(valid?: false)

      expect {
        subject.enable_publishing!
      }.to raise_error ActiveRecord::RecordInvalid
    end
  end

  describe '#finish_current_auction!' do
    it 'does not raise error if no current auction present' do
      subject.stubs(current_auction: nil)

      expect {
        subject.finish_current_auction!
      }.to_not raise_error
    end

    it 'queues current auction for finishing' do
      auction = build_stubbed(:auction, :published)
      subject.stubs(current_auction: auction)

      auction.expects(:queue_for_finishing!)

      subject.finish_current_auction!
    end
  end

  describe '#current_auction' do
    it 'is nil if last auction is nil' do
      subject.stubs(last_auction: nil)

      expect(subject.current_auction).to be_nil
    end

    it 'equals last auction if last auction is published' do
      auction = build_stubbed :auction, :published
      subject.stubs(last_auction: auction)

      expect(subject.current_auction).to eq(auction)
    end

    it 'is nil if last auction is queued_for_finishing' do
      auction = build_stubbed :auction, :queued_for_finishing
      subject.stubs(last_auction: auction)

      expect(subject.current_auction).to be_nil
    end

    it 'is nil if last auction is ended' do
      auction = build_stubbed :auction, :ended
      subject.stubs(last_auction: auction)

      expect(subject.current_auction).to be_nil
    end
  end

  describe '#last_auction' do
    it 'returns nil if no auctions present' do
      subject.stubs(auctions: [])

      expect(subject.last_auction).to be_nil
    end

    it 'returns last auction if auctions present' do
      auctions = build_stubbed_list :auction, 2
      subject.stubs(auctions: auctions)

      expect(subject.last_auction).to eq(auctions.last)
    end
  end

  describe '#end_publishing!' do
    it 'disables publishing and finishes current auction' do
      subject.expects(:disable_publishing!).once
      subject.expects(:finish_current_auction!).once

      subject.end_publishing!
    end
  end

  describe '#finish_current_immediately' do
    subject { create :template }

    it 'finishes current auction after update if #finish is set to true' do
      subject.expects(:finish_current_auction!)

      subject.update_attributes(finish_current_immediately: true)
    end

    it 'does not finishes current auction after update if #finis is set to false' do
      subject.expects(:finish_current_auction!).never

      subject.update_attributes(finish_current_immediately: false)
    end
  end

  it '#inspect' do
    expect(subject.inspect).to eq "<##{subject.id} enabled:#{subject.publishing_enabled?}, published:#{subject.current_auction.present?}>"
  end

  describe 'on destroy', :destroy do
    subject { create :published_auction_template }
    before { AlleApi::Api.any_instance.stubs(:finish_auction) }

    it 'disables publishing' do
      subject.destroy
      expect(subject.publishing_enabled?).to be_false
    end

    it 'kills all auctions' do
      AlleApi::Auction.any_instance.expects(:kill!)
      subject.destroy
    end
  end
end
