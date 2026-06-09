FactoryBot.define do
  factory :category do
    group 
    sequence(:name) { |n| "カテゴリー#{n}" }
  end
end