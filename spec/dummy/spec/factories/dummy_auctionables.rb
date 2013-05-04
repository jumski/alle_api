# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dummy_auctionable, aliases: [:auctionable] do
    title "Dummy"
    weight 1

    trait :with_category do
      category { FactoryGirl.create :category }
    end
  end
end
