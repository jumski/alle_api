
FactoryGirl.define do
  factory :event_wrapper, class: 'AlleApi::Wrapper::Event' do
    skip_create

    remote_id 23
    remote_auction_id 17
    remote_seller_id 10
    current_price 8
    occured_at { 1.minute.ago }
    kind { 'now' }

    initialize_with do
      new({
        remote_id: remote_id,
        remote_auction_id: remote_auction_id,
        remote_seller_id: remote_seller_id,
        current_price: current_price,
        occured_at: occured_at,
        kind: kind
      })
    end
  end
end
