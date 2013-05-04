
module AlleApi
  class AuctionEvent
    class End < AuctionEvent
      def alter_auction_state
        auction.end!
      end
    end
  end
end
