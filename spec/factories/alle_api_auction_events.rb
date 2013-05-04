
FactoryGirl.define do
  %w(start end buy_now update).each do |event|
    factory :"auction_event_#{event}",   class: "AlleApi::AuctionEvent::#{event.camelize}" do
      remote_id 1
      remote_auction_id 1
      remote_seller_id 1
      current_price "9.99"
      occured_at { Time.now }
      account

      trait(:triggered) do
        triggered_at { DateTime.now }
      end
    end
  end
end
