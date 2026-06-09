FactoryBot.define do
  factory :item do
    group
    category
    name { "牛乳" }
    quantity { 1 }
    purchased_at { Date.current }
    expired_at { Date.current + 7.days }
    memo { "テスト用メモ" }
  end
end
