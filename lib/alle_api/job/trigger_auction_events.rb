
module AlleApi
  module Job
    class TriggerAuctionEvents < Base
      sidekiq_options unique: true, unique_job_expiration: 24.hours

      def perform(account_id)
        account = AlleApi::Account.find(account_id)

        account.untriggered_events.each(&:trigger)
      end
    end
  end
end
