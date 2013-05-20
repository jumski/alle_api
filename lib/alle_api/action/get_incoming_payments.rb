module AlleApi
  module Action
    class GetIncomingPayments < Base
      def soap_action
        :do_get_my_incoming_payments
      end

      def request_body(params)
        { 'session-handle'       => client.session_handle,
          'buyer-id'             => params[:buyer_id],
          'item-id'              => params[:auction_id],
          'trans-recv-date-from' => params[:date_from],
          'trans-recv-date-to'   => params[:date_to],
          'trans-page-limit'     => params[:limit],
          'trans-offset'         => params[:offset] }
      end

      def extract_results(*a)
        true
      end
    end
  end
end
