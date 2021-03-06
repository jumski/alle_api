
module AlleApi
  module Job
    class TriggerAuctionEvents < Base
      sidekiq_options unique: :until_and_while_executing, unique_job_expiration: 3.minutes

      def perform(account_id)
        account = AlleApi::Account.find(account_id)

        account.untriggered_events.each(&:trigger)
      end
    end
  end
end
