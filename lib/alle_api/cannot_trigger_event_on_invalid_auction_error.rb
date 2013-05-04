
module AlleApi
  class CannotTriggerEventOnInvalidAuctionError < RuntimeError
    def initialize(auction, event)
      @auction, @event = auction, event
    end

    def message
      %Q{CANNOT TRIGGER EVENT ON INVALID AUCTION!
========================================
auction#id = #{@auction.id}
event#remote_id = #{@event.remote_id}
========================================
#{YAML.dump @auction}
========================================
#{YAML.dump @event}
}
    end
  end
end
