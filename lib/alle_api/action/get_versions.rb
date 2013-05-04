
module AlleApi
  module Action
    class GetVersions < Base
      def soap_action
        :do_query_all_sys_status
      end

      def request_body
        { 'country-id' => client.country_id,
          'webapi-key' => client.webapi_key }
      end

      def extract_results(result)
        version = result[:sys_country_status][:item].find do |version|
          version[:country_id].to_i == client.country_id
        end

        { country_id:      version[:country_id].to_i,
          version_key:     version[:ver_key],
          categories_tree: version[:cats_version],
          fields:          version[:form_sell_version] }
      end
    end
  end
end
