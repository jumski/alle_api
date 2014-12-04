module AlleApi
  module Action
    class GetDealsJournal < Base
      def soap_action
        :do_get_site_journal_deals
      end

      def request_body(starting_point = nil)
        { session_id: client.session_handle, journal_start: starting_point }
      end

      def extract_results(result)
        AlleApi::Wrapper::DealEvent.wrap_multiple extract_items(result)
      end

      def extract_items(result)
        result[:site_journal_deals] && result[:site_journal_deals][:item]
      end
    end
  end
end
