
module AlleApi
  module Action
    class GetFields < Base
      def soap_action
        :do_get_sell_form_fields_ext
      end

      def request_body
        { 'webapi-key' => client.webapi_key,
          'country-code' => client.country_id,
          'local-version' => 0 }
      end

      def extract_results(result)
        items = extract_items(result)
        AlleApi::Wrapper::Field.wrap_multiple(items)
      end

      def extract_items(result)
        result[:sell_form_fields][:item]
      end
    end
  end
end
