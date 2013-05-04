
module AlleApi
  module Job
    class UpdateFields < Base
      sidekiq_options unique: true, unique_job_expiration: 4.hours

      def perform
        api = AlleApi.utility_api
        Helper::FieldsSynchronizer.new(api).synchronize!
      end
    end
  end
end
