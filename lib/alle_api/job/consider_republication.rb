module AlleApi
  module Job
    class ConsiderRepublication < Base
      def perform(auction_template_id)
        auction_template = AlleApi::AuctionTemplate.find(auction_template_id)

        if auction_template.current_auction
          msg = "FROM_JOB #{DateTime.now.to_s(:db)} || AuctionTemplate#consider_republication_async called for template=#{auction_template.id}, but there is current auction (#{auction_template.current_auction.id}) present"

          Rails.logger.alle_api_debug.info(msg)
          raise RuntimeError, msg
        end

        auction_template.publish_next_auction if auction_template.publishing_enabled?
      end

    end
  end
end
