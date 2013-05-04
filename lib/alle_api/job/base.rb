
module AlleApi
  module Job
    class Base
      cattr_accessor :logger
      self.logger = Logger.new(STDOUT)

      include Sidekiq::Worker
      sidekiq_options backtrace: true, queue: :alle_api

      class << self
        def perform(*args)
          new.perform(*args)
        end
      end
    end
  end
end
