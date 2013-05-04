require 'spec_helper'
require 'rspec/state_machine_macros'
require 'rspec/freezed_time_context'

describe AlleApi::AuctionStateMachine do
  extend StateMachineMacros
  include_context "freezed time"

  before { AlleApi::Job::PublishAuction.jobs.clear }
  after  { AlleApi::Job::PublishAuction.jobs.clear }

  let(:template) { subject.template }
  let(:account)  { subject.account }
  let(:event_args) { [] }

  def self.it_calls_event_handler_if_present
    context 'if event handler present' do
      let(:handler) { mock("#{event} handler") }
      before { AlleApi.config["auction_#{event}_handler"] = handler }
      after  { AlleApi.config.delete "auction_#{event}_handler" }

      it 'calls event handler passing auction and auctionable' do
        handler.expects(:call).with(subject, subject.auctionable)

        subject.send("#{event}!", *event_args)
      end

      context 'when handler raises an error' do
        it 'does not change state' do
          spec_only_test_error = Class.new(StandardError)
          handler.stubs(:call).raises(spec_only_test_error)

          expect {
            begin
              subject.send("#{event}!", *event_args)
            rescue spec_only_test_error
              # we expect this
            end
          }.to_not change(subject, :state)
        end
      end
    end
  end

  context 'when not saved' do
    subject { build :auction }

    context 'and calling #queue_for_publication!' do
      it 'halts! transition' do
        expect {
          subject.queue_for_publication
        }.to raise_error(/Cannot publish unsaved auction!/)
      end
    end

    it_does_not_allow_event :publish
    it_does_not_allow_event :buy_now
    it_does_not_allow_event :end
    it_does_not_allow_event :queue_for_finishing
  end

  context 'when created' do
    subject { create :auction, :with_template }

    it { should be_created }
    its(:remote_id)     { should be_nil }
    its(:published_at)  { should be_nil }
    its(:bought_now_at) { should be_nil }
    its(:ended_at)      { should be_nil }

    context 'and calling #queue_for_publication!' do
      let(:event) { :queue_for_publication }

      it_transits_to :queued_for_publication
      it_updates_timestamp :queued_for_publication_at
      it_does_not_change :remote_id
      it_calls_event_handler_if_present

      it 'enqueues publish auction job' do
        subject.queue_for_publication!

        time = 2.seconds.from_now
        expectation = have_queued_job_at(time, subject.id)

        expect(AlleApi::Job::PublishAuction).to expectation
      end
    end

    it_does_not_allow_event :publish
    it_does_not_allow_event :end
    it_does_not_allow_event :buy_now
    it_does_not_allow_event :queue_for_finishing
  end

  context 'when queued_for_publication' do
    subject do
      create :auction, :queued_for_publication, :with_template
    end

    context 'and calling #publish!' do
      let(:event) { :publish }
      let(:event_args) { [123] }

      it_transits_to :published
      it_updates_timestamp :published_at
      it_calls_event_handler_if_present

      specify do
        expect {
          subject.publish!(123)
          subject.reload
        }.to change(subject, :remote_id).to(123)
      end
    end

    it_does_not_allow_event :queue_for_publication
    it_does_not_allow_event :end
    it_does_not_allow_event :buy_now
    it_does_not_allow_event :queue_for_finishing
  end

  context 'when published' do
    subject { create :auction, :published, :with_template }

    context 'and calling #end!' do
      let(:event) { :end }

      it_transits_to :ended
      it_updates_timestamp :ended_at
      it_does_not_change :remote_id
      it_calls_event_handler_if_present

      it 'calls template#consider_republication' do
        template.expects(:consider_republication)
        subject.end!
      end
    end

    context 'and calling #buy_now!' do
      let(:event) { :buy_now }

      it_transits_to :bought_now
      it_updates_timestamp :bought_now_at
      it_does_not_change :remote_id
      it_calls_event_handler_if_present
    end

    context 'and calling queue_for_finishing!' do
      let(:event) { :queue_for_finishing }

      it_transits_to :queued_for_finishing
      it_updates_timestamp :queued_for_finishing_at
      it_does_not_change :remote_id
      it_calls_event_handler_if_present

      it 'enqueues finish auction job' do
        subject.queue_for_finishing!

        time = 2.seconds.from_now
        expectation = have_queued_job_at(time, subject.id)

        expect(AlleApi::Job::FinishAuction).to expectation
      end
    end

    it_does_not_allow_event :queue_for_publication
    it_does_not_allow_event :publish
  end

  context 'when ended' do
    subject { create :auction, :ended, :with_template }

    it_does_not_allow_event :publish
    it_does_not_allow_event :end
    it_does_not_allow_event :buy_now
    it_does_not_allow_event :queue_for_publication
    it_does_not_allow_event :queue_for_finishing
  end

  context 'when bought now' do
    subject { create :auction, :ended, :with_template }

    it_does_not_allow_event :publish
    it_does_not_allow_event :end
    it_does_not_allow_event :buy_now
    it_does_not_allow_event :queue_for_publication
    it_does_not_allow_event :queue_for_finishing
  end

  context 'when queued_for_finishing' do
    subject do
      create :auction, :queued_for_finishing, :with_template
    end

    context 'and calling #end!' do
      let(:event) { :end }

      it_transits_to :ended
      it_updates_timestamp :ended_at
      it_does_not_change :remote_id
      it_calls_event_handler_if_present
    end

    it_does_not_allow_event :publish
    it_does_not_allow_event :buy_now
    it_does_not_allow_event :queue_for_publication
    it_does_not_allow_event :queue_for_finishing
  end
end
