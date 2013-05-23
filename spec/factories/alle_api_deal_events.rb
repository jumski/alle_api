# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :alle_api_deal_event, aliases: [:deal_event], class: 'AlleApi::DealEvent' do
    sequence(:remote_id) {|n| n}
    remote_auction_id 1
    occured_at { DateTime.now }
    remote_seller_id 1
    remote_buyer_id 1
    remote_deal_id 1
    remote_transaction_id 0
    quantity 1
    auction

    factory :new_deal, class: 'AlleApi::DealEvent::NewDeal'
    factory :fresh_new_transaction, class: 'AlleApi::DealEvent::NewTransaction'

    factory :new_transaction, class: 'AlleApi::DealEvent::NewTransaction' do
      association :post_buy_form, factory: :post_buy_form,
        payment_type: :payu_checkout, payment_status: :started
    end

    factory :cancel_transaction, class: 'AlleApi::DealEvent::CancelTransaction'
    factory :finish_transaction, class: 'AlleApi::DealEvent::FinishTransaction'

  end
end
