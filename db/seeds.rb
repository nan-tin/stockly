user = User.find_or_create_by!(email: "test@example.com") do |u|
  u.password = "password"
end

group = Group.find_or_create_by!(invite_code: "12345678")

GroupUser.find_or_create_by!(
  user: user,
  group: group
) do |gu|
  gu.display_name = "ron"
end

Category.find_or_create_by!(
  group: group,
  name: "食品"
)

Category.find_or_create_by!(
  group: group,
  name: "日用品"
)

food = Category.find_by!(name: "食品")

Item.find_or_create_by!(
  group: group,
  category: food,
  name: "牛乳",
) do |item|
  item.quantity = 2
  item.purchased_at = Date.today
end

Item.find_or_create_by!(
  group: group,
  category: food,
  name: "卵",
) do |item|
  item.quantity = 10
end

