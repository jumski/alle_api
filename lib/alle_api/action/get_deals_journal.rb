module AlleApi
  module Action
    class GetDealsJournal < Base
      def soap_action
        :do_get_site_journal_deals
      end

      def request_body(starting_point = nil)
        { 'session-id' => client.session_handle,
          'journal-start' => starting_point }
      end

      def extract_results(result)
        result
      end
    end
  end
end
