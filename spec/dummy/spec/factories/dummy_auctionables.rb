# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dummy_auctionable, aliases: [:auctionable] do
    title "Dummy"
    weight 1

    trait :with_category do
      category_id { FactoryGirl.create(:category).id }
    end
  end
end
