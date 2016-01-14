module AlleApi::Action
  class GetItemInfo < Base
    def soap_action
      :do_show_item_info_ext
    end

    def request_body(remote_id)
      {
        session_handle: client.session_handle,
        item_id: remote_id
      }
    end

    def extract_results(result)
      result
    end
  end
end
