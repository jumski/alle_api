
module AlleApi
  module Job
    class PublishAuction < Base
      def perform(auction_id)
        logger.info "Publishing auction with id #{auction_id} on #{DateTime.now}"
        auction = AlleApi::Auction.find(auction_id)
        api = auction.account.api

        unless auction.queued_for_publication?
          raise InvalidAuctionForPublicationError,
            'I can only publish queued_for_publication auctions'
        end

        begin
          results = api.create_auction(auction.to_allegro_auction)
        rescue
          logger.info "Failed to publish! (#{$!.class}: #{$!})"
          raise $!
        end

        logger.info "Successyfully published. Item id = #{results[:item_id]}"
        auction.publish!(results[:item_id])
      end

    end
  end
end
