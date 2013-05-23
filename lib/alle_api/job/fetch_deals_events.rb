module AlleApi
  module Job
    class FetchDealsEvents < Base
      sidekiq_options unique: true, unique_job_expiration: 10.minutes

      def perform(account_id)
        account = AlleApi::Account.find(account_id)
        api = account.api

        entries = api.get_deals_journal
        entries.each(&:create_deal_event)

        # TriggerAuctionEvents.perform_in(5.seconds, account.id)
      end
    end
  end
end
