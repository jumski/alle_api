
module AlleApi
  module Action
    class Authenticate < Base
      def soap_action
        :do_login
      end

      def request_body
        { 'user-login'    => client.login,
          'user-password' => client.password,
          'country-code'  => AlleApi::Client::COUNTRY_POLAND,
          'webapi-key'    => client.webapi_key,
          'local-version' => client.version_key }
      end

      def extract_results(results)
        results[:session_handle_part]
      end
    end
  end
end
