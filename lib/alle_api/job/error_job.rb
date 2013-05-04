
module AlleApi
  module Job
    class ErrorJob
      class << self
        def perform
          raise 'omg diz iz haxxx'
        end
      end
    end
  end
end
