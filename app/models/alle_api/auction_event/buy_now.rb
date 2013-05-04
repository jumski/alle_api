
module AlleApi
  class AuctionEvent
    class BuyNow < AuctionEvent
      def alter_auction_state
        auction.buy_now!
      end
    end
  end
end
