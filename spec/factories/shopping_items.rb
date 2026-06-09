FactoryBot.define do
  factory :shopping_item do
    shopping_list
    category
    name { "卵" }
    quantity { 1 }
    memo { "テスト用メモ" }
    is_purchased { false }
  end
end