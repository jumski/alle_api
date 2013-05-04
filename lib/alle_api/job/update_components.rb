
module AlleApi
  module Job
    class UpdateComponents < Base
      sidekiq_options unique: true, unique_job_expiration: 3.minutes

      def perform
        Helper::ComponentsUpdater.new.update!
      end
    end
  end
end
