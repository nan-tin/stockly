FactoryBot.define do
  factory :inquiry do
    association :user
    inquiry_type { :bug }
    email { "reply@example.com" }
    content { "お問い合わせ本文です" }
  end
end