module AlleApi
  module Job
    class FetchDealEvents < Base
      sidekiq_options unique: true, unique_job_expiration: 10.minutes

      def perform(account_id)
        account = AlleApi::Account.find(account_id)
        api = account.api

        starting_point = account.last_deal_event_remote_id + 1
        entries = api.get_deals_journal(starting_point)
        entries.each(&:create_if_missing)
      end
    end
  end
end
