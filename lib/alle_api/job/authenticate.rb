

module AlleApi
  module Job
    class Authenticate < Base
      def perform(account_id)
        account = AlleApi::Account.find(account_id)
        api, client = account.api, account.api.client

        client.session_handle = api.authenticate
      end
    end
  end
end
