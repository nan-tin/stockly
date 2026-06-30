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

  describe ".from_omniauth" do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "123456789",
        info: {
          email: "google_user@example.com"
        }
      )
    end

    it "Google認証情報からユーザーを作成できること" do
      expect {
        described_class.from_omniauth(auth)
      }.to change(described_class, :count).by(1)
    end

    it "providerとuidが同じ場合は既存ユーザーを返すこと" do
      user = described_class.from_omniauth(auth)

      expect {
        described_class.from_omniauth(auth)
      }.not_to change(described_class, :count)

      expect(described_class.from_omniauth(auth)).to eq user
    end

    it "既存のメールアドレスを持つユーザーにGoogleアカウントを紐付けること" do
      user = create(:user, email: "google_user@example.com")

      expect {
        described_class.from_omniauth(auth)
      }.not_to change(User, :count)

      user.reload

      expect(user.provider).to eq "google_oauth2"
      expect(user.uid).to eq "123456789"
    end
  end
end