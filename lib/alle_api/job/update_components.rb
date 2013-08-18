
module AlleApi
  module Job
    class UpdateComponents < Base
      sidekiq_options unique: true, unique_job_expiration: 24.hours

      def perform
        Helper::ComponentsUpdater.new.update!
      end
    end
  end
end
