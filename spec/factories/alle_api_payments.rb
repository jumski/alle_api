# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :alle_api_payment, aliases: [:payment], class: 'AlleApi::Payment' do
    remote_id 1
    remote_auction_id 1
    buyer_id 1
    kind "MyString"
    status "MyString"
    amount 1.5
    postage_amount 1.5
    created_at "2013-05-22 15:37:34"
    received_at "2013-05-22 15:37:34"
    price 1.5
    count 1
    details "MyString"
    completed false
    parent_remote_id 1
    source "MyString"
  end
end
