require 'spec_helper'
require 'rspec/freezed_time_context'

SPEC_ONLY_TEST_ERROR = Class.new(ArgumentError)

describe AlleApi::AuctionEvent do
  include_context 'freezed time'

  describe :Associations do
    it { should belong_to :account }
    it { should belong_to :auction }
    it { should have_one(:auctionable).through(:auction) }
    it { should have_one(:template).through(:auction) }
  end

  it { should validate_presence_of :type }
  it { should validate_presence_of :account }

  it { should_not be_triggered }
  its(:triggered_at) { should be_nil }

  its(:raised_error) { should be_nil }

  def self.it_makes_event_triggered
    it '#trigger makes event triggered' do
      expect {
        subject.trigger rescue SPEC_ONLY_TEST_ERROR
        subject.reload
        expect(subject.triggered_at.in_time_zone.to_s).to eq(time_now.in_time_zone.to_s)
      }.to change(subject, :triggered?).from(false).to(true)
    end
  end

  def self.it_does_not_raise_errors
    it '#trigger does not raise any errors' do
      expect { subject.trigger }.to_not raise_error
    end
  end

  def self.it_does_not_change_initial_state
    it '#trigger does not change initial state' do
      expect {
        subject.trigger rescue SPEC_ONLY_TEST_ERROR
      }.to_not change(subject, :initial_state)
    end
  end

  def self.it_sets_raised_error(error_name)
    it "#trigger sets raised_error to '#{error_name}'" do
      expect {
        subject.trigger rescue SPEC_ONLY_TEST_ERROR
        subject.reload
      }.to change(subject, :raised_error).from(nil).to(error_name)
    end
  end

  def self.it_does_not_change_altered_state
    it '#trigger does not save altered state' do
      auction.stubs(state: :ended)
      expect {
        subject.trigger rescue SPEC_ONLY_TEST_ERROR
        subject.reload
      }.to_not change(subject, :altered_state)
    end
  end

  describe '#trigger' do
    context 'when auction is empty' do
      subject { create :auction_event_end }
      before { subject.stubs(:alter_auction_state) }

      it_makes_event_triggered
      it_does_not_raise_errors

      it 'does not call #alter_auction_state' do
        subject.expects(:alter_auction_state).never

        subject.trigger
      end

      its(:initial_state) { should be_nil }
    end

    context 'when auction is present' do
      let(:auction) { create :auction }
      subject { create :auction_event_end, auction: auction }

      its(:initial_state) { should eq(auction.state) }

      context 'when is triggered' do
        before { subject.stubs(triggered?: true) }

        it_does_not_change_altered_state
        it_does_not_change_initial_state

        it 'raises CannotTriggerTriggeredError' do
          expect {
            subject.trigger
          }.to raise_error(AlleApi::AuctionEvent::CannotTriggerTriggeredError)
        end

        it 'does not changes triggered_at timestamp' do
          expect {
            subject.trigger rescue AlleApi::AuctionEvent::CannotTriggerTriggeredError
          }.to_not change(subject, :triggered_at)
        end

        it '#trigger does not call alter_auction_state' do
          subject.expects(:alter_auction_state).never
          subject.trigger rescue AlleApi::AuctionEvent::CannotTriggerTriggeredError
        end
      end

      context 'when #alter_auction_state raises NoTransitionAllowed' do
        before do
          subject.stubs(:alter_auction_state).
            raises(Workflow::NoTransitionAllowed)
        end

        it_makes_event_triggered
        it_does_not_raise_errors
        it_does_not_change_altered_state
        it_sets_raised_error('Workflow::NoTransitionAllowed')
      end

      context 'when #alter_auction_state raises SPEC_ONLY_TEST_ERROR' do
        before { subject.stubs(:alter_auction_state).raises(SPEC_ONLY_TEST_ERROR) }

        it_makes_event_triggered
        it_does_not_change_initial_state
        it_does_not_change_altered_state

        it '#trigger re-raises raised error' do
          expect { subject.trigger }.to raise_error(SPEC_ONLY_TEST_ERROR)
        end

        it_sets_raised_error(SPEC_ONLY_TEST_ERROR.name)
      end

      context 'when auction is invalid and cannot be saved' do
        before { auction.stubs(valid?: false) }

        it_makes_event_triggered
        it_does_not_change_initial_state
        it_does_not_change_altered_state
        it_sets_raised_error('AlleApi::CannotTriggerEventOnInvalidAuctionError')
        it '#trigger raises CannotTriggerEventOnInvalidAuctionError' do
          error = AlleApi::CannotTriggerEventOnInvalidAuctionError
          expect {
            subject.trigger
          }.to raise_error(error)
        end
      end

      context 'when #alter_auction_state does not raise error' do
        before do
          subject.expects(:alter_auction_state)
        end

        it_makes_event_triggered
        it_does_not_raise_errors
        it_does_not_change_initial_state

        it '#trigger saves destination state' do
          auction.stubs(state: :ended)
          expect {
            subject.trigger
          }.to change(subject, :altered_state).from(nil).to(:ended)
        end
      end
    end
  end # #trigger

  describe '.invalid_transition' do
    before do
      @transition_error = create :auction_event_end, :triggered,
        raised_error: 'Workflow::NoTransitionAllowed'
      @other_error = create :auction_event_end, :triggered,
        raised_error: SPEC_ONLY_TEST_ERROR.name
    end

    subject { described_class.invalid_transition }

    it { should include(@transition_error) }
    it { should_not include(@other_error) }
  end

  describe '.auction_invalid' do
    before do
      @validity_error = create :auction_event_end, :triggered,
        raised_error: 'AlleApi::CannotTriggerEventOnInvalidAuctionError'
      @other_error = create :auction_event_end, :triggered,
        raised_error: SPEC_ONLY_TEST_ERROR.name
    end

    subject { described_class.auction_invalid }

    it { should include(@validity_error) }
    it { should_not include(@other_error) }
  end

  describe '#triggered?' do
    it 'returns false if #triggered_at is nil' do
      subject.triggered_at = nil
      expect(subject).to_not be_triggered
    end

    it 'returns true if #triggered_at is some date' do
      subject.triggered_at = time_now
      expect(subject).to be_triggered
    end
  end

end
