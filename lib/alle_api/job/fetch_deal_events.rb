module AlleApi
  module Job
    class FetchDealEvents < Base
      sidekiq_options unique: true, unique_job_expiration: 24.hours

      def perform(account_id, starting_point = nil)
        account = AlleApi::Account.find(account_id)
        api = account.api

        unless starting_point
          starting_point = account.last_deal_event_remote_id + 1
        end

        entries = api.get_deals_journal(starting_point)
        entries.each(&:create_if_missing)
      end
    end
  end
end
