
module AlleApi
  module Job
    class FetchAuctionEvents < Base
      sidekiq_options unique: :until_and_while_executing, unique_job_expiration: 3.minutes

      def perform(account_id, starting_point = nil)
        account = AlleApi::Account.find(account_id)
        api = account.api

        unless starting_point
          starting_point = account.last_auction_event_remote_id + 1
        end

        entries = api.get_journal(starting_point)
        entries.each do |entry|
          entry.create_auction_event(account)
        end

        TriggerAuctionEvents.perform_in(5.seconds, account.id)
      end
    end
  end
end
