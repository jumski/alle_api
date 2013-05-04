
module AlleApi
  module Job
    class FetchAuctionEvents < Base
      sidekiq_options unique: true, unique_job_expiration: 60

      def perform(account_id)
        account = AlleApi::Account.find(account_id)
        api = account.api

        starting_point = account.last_auction_event_remote_id + 1
        entries = api.get_journal(starting_point)
        entries.each do |entry|
          entry.create_auction_event(account)
        end

        TriggerAuctionEvents.perform_in(5.seconds, account.id)
      end
    end
  end
end
