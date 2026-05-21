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

