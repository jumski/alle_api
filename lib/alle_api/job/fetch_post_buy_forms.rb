module AlleApi
  module Job
    class FetchPostBuyForms < Base
      sidekiq_options unique: true, unique_job_expiration: 10.minutes

      def perform(account_id)
        account = AlleApi::Account.find(account_id)
        api = account.api

        transaction_ids = account.missing_transaction_ids

        post_buy_forms = api.get_post_buy_forms_for_sellers(transaction_ids)
        post_buy_forms.each do |post_buy_form|
          post_buy_form.create_if_missing(account)
        end
      end
    end
  end
end
