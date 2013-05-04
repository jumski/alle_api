
module AlleApi
  class AuctionEvent
    class Update < AuctionEvent
      def alter_auction_state
        auction.touch
      end
    end
  end
end
