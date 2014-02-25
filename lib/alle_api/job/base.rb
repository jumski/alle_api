
module AlleApi
  module Job
    class Base
      cattr_accessor :logger
      self.logger = Logger.new(STDOUT)

      include Sidekiq::Worker
      sidekiq_options backtrace: true, queue: :alle_api
    end
  end
end
