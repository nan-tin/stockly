FactoryBot.define do
  factory :group_user do
    user
    group
    display_name { "ron" }
  end
end
