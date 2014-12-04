module AlleApi
  module Action
    class GetPostBuyFormsForSellers < Base
      def soap_action
        :do_get_post_buy_forms_data_for_sellers
      end

      def validate!(ids)
        raise "Please provide some ids!" if ids.blank?
      end

      def request_body(ids)
        {
          session_id: client.session_handle,
          transactions_ids_array: { item: ids }
        }
      end

      def extract_results(input)
        AlleApi::Wrapper::PostBuyForm.wrap_multiple extract_items(input)
      end

      def extract_items(result)
        result[:post_buy_form_data][:item]
      end
    end
  end
end
