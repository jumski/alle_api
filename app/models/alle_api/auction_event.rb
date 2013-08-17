module AlleApi
  class AuctionEvent < ActiveRecord::Base
    attr_accessible :auction_id, :account_id, :current_price, :occured_at,
      :remote_auction_id, :remote_id, :remote_seller_id, :account, :auction

    validates :type, :account, presence: true

    belongs_to :account
    belongs_to :auction
    has_one :auctionable, through: :auction
    has_one :template, through: :auction

    before_create :steal_initial_state, if: :auction
    def steal_initial_state
      self.initial_state = auction.state
    end

    class << self
      def invalid_transition
        where(raised_error: 'Workflow::NoTransitionAllowed')
      end

      def auction_invalid
        where(raised_error: 'AlleApi::CannotTriggerEventOnInvalidAuctionError')
      end
    end

    def trigger
      raise CannotTriggerTriggeredError if triggered?

      if auction.present?
        unless auction.valid?
          error_klass = AlleApi::CannotTriggerEventOnInvalidAuctionError
          self.raised_error = error_klass.name
          raise error_klass.new(auction, self)
        end

        begin
          alter_auction_state
          self.altered_state = auction.state
        rescue Workflow::NoTransitionAllowed => e
          # we accept this, no re-rasing here
          self.raised_error = e.class.name
        rescue Exception => e
          self.raised_error = e.class.name
          raise e
        end
      end

    ensure
      self.triggered_at = DateTime.now unless triggered?
      self.save
    end

    def triggered?
      triggered_at.present?
    end

    class CannotTriggerTriggeredError < RuntimeError; end
  end
end
