require "rails_helper"

RSpec.describe Group, type: :model do
  describe "アソシエーション" do
    it "ユーザーを持てること" do
      group = create(:group)
      user = create(:user)

      GroupUser.create!(
        group: group,
        user: user,
        display_name: "ron"
      )

      expect(group.users).to include(user)
    end
  end
end