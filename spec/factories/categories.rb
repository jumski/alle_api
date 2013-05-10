# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :alle_api_category, aliases: [:category], class: 'AlleApi::Category' do
    sequence(:name) { |n| "Category #{n}"}

    trait :with_children do
      after(:create) do |category, evaluator|
        FactoryGirl.create(:category, parent: category)
      end
    end

    trait(:branch)  { leaf_node false }
    trait(:leaf)    { leaf_node true }
    trait(:removed) { soft_removed_at DateTime.now }

    trait(:with_condition_field) do
      after(:create) do |category, evaluator|
        FactoryGirl.create_list(:field, 1, :condition_field,
                                category: category)
      end
    end

  end
end
