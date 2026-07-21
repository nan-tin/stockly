FactoryBot.define do
  factory :group do
    sequence(:invite_code) { |n| "code#{n}" }
    association :owner, factory: :user
  end
end