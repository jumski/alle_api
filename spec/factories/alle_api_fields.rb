# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :alle_api_field, aliases: [:field], class: 'AlleApi::Field' do
    param_id 1
    parent_param_id 1
    sequence(:default_value)        { |n| "default_value #{n}" }
    sequence(:description)          { |n| "description #{n}" }
    sequence(:form_type)            { |n| "form_type #{n}" }
    sequence(:max_length)           { |n| "max_length #{n}" }
    sequence(:max_value)            { |n| "max_value #{n}" }
    sequence(:min_value)            { |n| "min_value #{n}" }
    sequence(:name)                 { |n| "name #{n}" }
    sequence(:options)              { |n| "options #{n}" }
    sequence(:options_descriptions) { |n| "options_descriptions #{n}" }
    sequence(:options_values)       { |n| "options_values #{n}" }
    sequence(:param_values)         { |n| "param_values #{n}" }
    sequence(:parent_param_value)   { |n| "parent_param_value #{n}" }
    sequence(:position)             { |n| "position #{n}" }
    sequence(:request_type)         { |n| "request_type #{n}" }
    sequence(:required)             { |n| "required #{n}" }
    sequence(:unit)                 { |n| "unit #{n}" }

    trait :with_category do
      category
    end

    trait :condition_field do
      name "Stan"
    end
  end
end
