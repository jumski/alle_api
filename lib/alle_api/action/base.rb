
module AlleApi::Action
  class Base
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def do(*args)
      validate!(*args)

      result = client.request soap_action, request_body(*args)
      result_to_extract = result.to_hash["#{soap_action}_response".to_sym]

      extract_results(result_to_extract)
    end

    def validate!(*args); end

    def request_body
      raise 'Abstract method - please implement!'
    end

    def extract_results
      raise 'Abstract method - please implement!'
    end
  end
end


