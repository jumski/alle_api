# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :alle_api_auction, aliases: [:auction], class: 'AlleApi::Auction' do
    title 'Auction'
    price 5.23
    economic_letter_price 1.1
    priority_letter_price 1.2
    priority_package_price 1.3
    economic_package_price 1.4
    additional_info 'info'
    state 'created'

    auctionable
    account

    trait(:queued_for_publication) { state 'queued_for_publication' }
    trait(:published) do
      state 'published'
      published_at { 10.days.ago }
    end
    trait(:ended) do
      state 'ended'
      ended_at { 10.days.ago }
    end
    trait(:bought_now) do
      state 'bought_now'
      bought_now_at { 10.days.ago }
    end
    trait(:queued_for_publication) do
      state 'queued_for_publication'
    end
    trait(:queued_for_finishing) do
      state 'queued_for_finishing'
    end

    trait(:with_template) { template }
  end
end
