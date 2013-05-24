module AlleApi
  module Job
    class FetchPostBuyForms < Base
      include Sidekiq::Worker

      def perform(account_id, transaction_ids)
        account = AlleApi::Account.find(account_id)
        api = account.api

        post_buy_forms = api.get_post_buy_forms_for_sellers(transaction_ids)
        post_buy_forms.each do |post_buy_form|
          post_buy_form.create_if_missing(account)
        end
      end
    end
  end
end
