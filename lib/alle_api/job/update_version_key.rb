module AlleApi
  module Job
    class UpdateVersionKey < Base
      sidekiq_options unique: true, unique_job_expiration: 1.minute

      def perform
        Helper::Versions.new.update :version_key
      end
    end
  end
end
