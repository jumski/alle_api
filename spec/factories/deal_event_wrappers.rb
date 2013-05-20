
FactoryGirl.define do
  factory :deal_event_wrapper, class: 'AlleApi::Wrapper::DealEvent' do
    skip_create

    remote_id 775599262
    occured_at { Time.at 1369042031 }
    remote_deal_id 896009896
    remote_transaction_id 243241703
    remote_seller_id 2783112
    remote_auction_id 3263045863
    remote_buyer_id 5697909
    quantity 1

    factory(:new_deal_wrapper) do
      kind 1
      remote_transaction_id 0
    end
    factory(:new_transaction_wrapper)    { kind 2 }
    factory(:cancel_transaction_wrapper) { kind 3 }
    factory(:finish_transaction_wrapper) { kind 4 }

    initialize_with do
      new({
        remote_id: remote_id,
        occured_at: occured_at,
        remote_deal_id: remote_deal_id,
        remote_transaction_id: remote_transaction_id,
        remote_seller_id: remote_seller_id,
        remote_auction_id: remote_auction_id,
        remote_buyer_id: remote_buyer_id,
        quantity: quantity,
      })
    end
  end
end
