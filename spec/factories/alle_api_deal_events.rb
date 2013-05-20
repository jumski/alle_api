# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :alle_api_deal_event, class: 'AlleApi::DealEvent' do
    remote_id 1
    remote_auction_id 1
    occured_at { DateTime.now }
    remote_seller_id 1
    remote_buyer_id 1
    remote_deal_id 1
    remote_transaction_id 1
    quantity 1

    factory :new_deal, class: 'AlleApi::DealEvent::NewDeal'
    factory :new_transaction, class: 'AlleApi::DealEvent::NewTransaction'
    factory :cancel_transaction, class: 'AlleApi::DealEvent::CancelTransaction'
    factory :finish_transaction, class: 'AlleApi::DealEvent::FinishTransaction'
  end
end
