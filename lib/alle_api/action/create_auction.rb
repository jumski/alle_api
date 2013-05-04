
module AlleApi::Action
  class CreateAuction < Base
    def soap_action
      :do_new_auction_ext
    end

    def validate!(auction)
      raise 'Invalid auction' unless auction.valid?
    end

    def request_body(auction)
      {
        'session-handle' => client.session_handle,
        'fields' => {'fields' => auction.to_fields_array}
      }
    end

    def extract_results(result)
      result
    end
  end
end

