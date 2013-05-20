module AlleApi
  module Action
    class GetTransactions < Base
      def soap_action
        :do_get_post_buy_forms_data_for_sellers
      end

      def validate!(ids)
        raise "Please provide some ids!" if ids.blank?
      end

      def request_body(ids)
        { 'session-id' => client.session_handle,
          'transactions-ids-array' => {
            'transactions-ids-array' => ids
          }
        }
      end

      def extract_results(input)
        extracted = input[:post_buy_form_data][:item]

        AlleApi::Wrapper::PostBuyForm.wrap_multiple(extracted)
      end
    end
  end
end
