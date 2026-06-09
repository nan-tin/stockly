FactoryBot.define do
  factory :consumption do
    group
    category
    category_name { "食品" }
    item_name { "牛乳" }
    consumed_at { Date.current }
    quantity { 1 }
    memo { "テスト用メモ" }
  end
end