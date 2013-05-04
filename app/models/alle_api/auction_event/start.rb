
module AlleApi
  class AuctionEvent
    class Start < AuctionEvent
      def alter_auction_state
        # no-op
      end
    end
  end
end
