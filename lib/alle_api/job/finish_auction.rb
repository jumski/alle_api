
module AlleApi
  module Job
    class FinishAuction < Base
      def perform(auction_id)
        logger.info "Finishing auction with id #{auction_id} on #{DateTime.now}"
        auction = AlleApi::Auction.find(auction_id)
        api = auction.account.api

        unless auction.queued_for_finishing?
          raise InvalidAuctionForFinishingError,
            'I can only finish queued_for_finishing auctions'
        end

        begin
          success = api.finish_auction(auction.remote_id)
        rescue
          logger.info "Failed to finish! (#{$!.class}: #{$!})"
          raise $!
        end

        if success
          logger.info "Successyfully finished."
          auction.end!
        else
          logger.info "Failed to finish!"
        end
      end
    end
  end
end
