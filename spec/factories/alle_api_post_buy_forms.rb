# encoding: utf-8

FactoryGirl.define do
  factory :alle_api_post_buy_form,
    aliases: [:post_buy_form, :post_buy_form_started],
    class: 'AlleApi::PostBuyForm' do

    sequence(:remote_id) {|n| n}
    buyer_id 1
    buyer_login "MyString"
    buyer_email "MyString"
    amount 1.5
    postage_amount 1.5
    invoice_requested false
    message_to_seller "MyString"
    payment_type "MyString"
    payment_id 1
    payment_status :started
    payment_created_at { DateTime.now }
    payment_received_at nil
    payment_cancelled_at nil
    payment_amount 1.5
    shipment_id 1
    source "MyString"
    shipment_address do
      { country: "Polska",
        address_1: "Address part 1" ,
        zipcode: "31-234",
        city: "Warszawa",
        full_name: "Jacek Placek",
        company_name: "Dunno",
        phone_number: "1234" }
    end

    factory :post_buy_form_cancelled do
      payment_status :cancelled
      payment_cancelled_at { DateTime.now }
    end

    factory :post_buy_form_rejected do
      payment_status :rejected
    end

    factory :post_buy_form_finished do
      payment_status :finished
      payment_received_at { DateTime.now }
      payment_created_at { payment_received_at - 1.day }
    end

    factory :post_buy_form_withdrawn do
      payment_status :withdrawn
    end
  end
end
