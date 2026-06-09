require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "有効なfactoryを持つこと" do
      user = build(:user)

      expect(user).to be_valid
    end

    it "メールアドレスがなければ無効なこと" do
      user = build(:user, email: nil)

      expect(user).not_to be_valid
    end

    it "パスワードがなければ無効なこと" do
      user = build(:user, password: nil)

      expect(user).not_to be_valid
    end
  end

  describe "コールバック" do
    it "ユーザー作成時にGroup,GroupUser,ShoppingListが作成されること" do
      user = create(:user)

      expect(user.groups.count).to eq 1
      expect(user.group_users.count).to eq 1
      expect(user.groups.first.shopping_list).to be_present
    end
  end
end