
module AlleApi::Action
  class GetJournal < Base
    def soap_action
      :do_get_site_journal
    end

    def request_body(starting_point = nil)
      { session_handle: client.session_handle,
        starting_point: starting_point,
        info_type:      0 }
    end

    def extract_results(result)
      items = extract_items(result)
      AlleApi::Wrapper::Event.wrap_multiple(items)
    end

    def extract_items(result)
      result[:site_journal_array] && result[:site_journal_array][:item]
    end
  end
end
