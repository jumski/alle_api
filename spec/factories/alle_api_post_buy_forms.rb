# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :alle_api_post_buy_form, aliases: [:post_buy_form], class: 'AlleApi::PostBuyForm' do
    remote_id 1
    buyer_id 1
    buyer_login "MyString"
    buyer_email "MyString"
    amount 1.5
    postage_amount 1.5
    invoice_requested false
    message_to_seller "MyString"
    payment_type "MyString"
    payment_id 1
    payment_status "MyString"
    payment_created_at "2013-05-22 16:06:47"
    payment_received_at "2013-05-22 16:06:47"
    payment_cancelled_at "2013-05-22 16:06:47"
    payment_amount 1.5
    shipment_id 1
    source "MyString"
  end
end
