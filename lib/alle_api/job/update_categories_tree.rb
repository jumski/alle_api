
module AlleApi
  module Job
    class UpdateCategoriesTree < Base
      sidekiq_options unique: :until_and_while_executing, unique_job_expiration: 3.minutes

      def perform
        api = AlleApi.utility_api
        Helper::CategoryTreeSynchronizer.new(api).synchronize!
      end
    end
  end
end
