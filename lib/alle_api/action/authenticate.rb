
module AlleApi
  module Action
    class Authenticate < Base
      def soap_action
        :do_login
      end

      def request_body
        { user_login:    client.login,
          user_password: client.password,
          country_code:  AlleApi::Client::COUNTRY_POLAND,
          webapi_key:    client.webapi_key,
          local_version: client.version_key }
      end

      def extract_results(results)
        results[:session_handle_part]
      end
    end
  end
end
