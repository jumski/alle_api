
module AlleApi::AuctionStateMachine
  extend ActiveSupport::Concern

  included do
    include Workflow

    workflow_column :state
    workflow do
      state :created do
        event :queue_for_publication,
          transitions_to: :queued_for_publication
      end

      state :queued_for_publication do
        event :publish, transitions_to: :published
      end

      state :published do
        event :end, transitions_to: :ended
        event :buy_now, transitions_to: :bought_now
        event :queue_for_finishing, transitions_to: :queued_for_finishing
      end

      state :ended
      state :bought_now
      state :queued_for_finishing do
        event :end, transitions_to: :ended
      end

      on_transition do |initial_state, destination_state, event, *args|
        if handler = AlleApi.config["auction_#{event}_handler"]
          handler.call(self, self.auctionable)
        end
      end
    end
  end

  def queue_for_publication
    halt! 'Cannot publish unsaved auction!' unless persisted?

    self.queued_for_publication_at = DateTime.now
    AlleApi::Job::PublishAuction.perform_at(2.seconds.from_now, id)
  end

  def publish(remote_id)
    self.remote_id = remote_id
    self.published_at = DateTime.now
  end

  def queue_for_finishing
    self.queued_for_finishing_at = DateTime.now
    AlleApi::Job::FinishAuction.perform_at(2.seconds.from_now, id)
  end

  def end
    self.ended_at = DateTime.now

    template.consider_republication
  end

  def buy_now
    self.bought_now_at = DateTime.now
  end
end
