user = User.create!(
  email: "test@example.com",
  password: "password"
)
  
group = Group.create!(
  invite_code: "12345678"
)

GroupUser.create!(
  user: user,
  group: group,
  display_name: "ron"
)
