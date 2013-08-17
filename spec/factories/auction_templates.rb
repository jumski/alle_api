# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :alle_api_auction_template, aliases: [:template], class: 'AlleApi::AuctionTemplate' do
    sequence(:title) { |n| "Template #{n}" }
    sequence(:price) { |n| 15.23 + n }
    sequence(:economic_letter_price) { |n| 11.1 + n }
    sequence(:priority_letter_price) { |n| 11.2 + n }
    sequence(:priority_package_price) { |n| 11.3 + n }
    sequence(:economic_package_price) { |n| 11.4 + n }
    sequence(:additional_info) { |n| "info #{n}" }

    auctionable
    account

    factory :published_auction_template do
      after(:create) do |template, evaluator|
        create :alle_api_auction, :published,
          template: template, auctionable: template.auctionable
      end
    end
  end
end
