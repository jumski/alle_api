
module AlleApi
  module Job
    class UpdateComponents < Base
      sidekiq_options unique: :until_and_while_executing, unique_job_expiration: 30.minutes

      def perform
        Helper::ComponentsUpdater.new.update!
      end
    end
  end
end
