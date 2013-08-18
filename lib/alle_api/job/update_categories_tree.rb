
module AlleApi
  module Job
    class UpdateCategoriesTree < Base
      sidekiq_options unique: true, unique_job_expiration: 24.hours

      def perform
        api = AlleApi.utility_api
        Helper::CategoryTreeSynchronizer.new(api).synchronize!
      end
    end
  end
end
