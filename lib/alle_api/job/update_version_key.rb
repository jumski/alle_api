module AlleApi
  module Job
    class UpdateVersionKey < Base
      sidekiq_options unique: :until_and_while_executing, unique_job_expiration: 15.seconds

      def perform
        Helper::Versions.new.update :version_key
      end
    end
  end
end
