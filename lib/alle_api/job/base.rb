
module AlleApi
  module Job
    class Base
      cattr_accessor :logger
      self.logger = Logger.new(STDOUT)

      include Sidekiq::Worker
      sidekiq_options backtrace: true, queue: :alle_api

      def self.each_account_async
        AlleApi::Account.active.pluck(:id).each { |id| perform_async(id) }
      end
    end
  end
end
