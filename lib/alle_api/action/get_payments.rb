module AlleApi
  module Action
    class GetPayments < Base
      def soap_action
        :do_get_my_incoming_payments
      end

      def request_body(params)
        { session_handle:       client.session_handle,
          buyer_id:             params[:buyer_id],
          item_id:              params[:auction_id],
          trans_recv_date_from: params[:date_from],
          trans_recv_date_to:   params[:date_to],
          trans_page_limit:     params[:limit],
          trans_offset:         params[:offset] }
      end

      def extract_results(result)
        Wrapper::Payment.wrap_multiple result[:pay_trans_income][:item]
      end
    end
  end
end
