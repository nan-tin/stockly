require "rails_helper"

RSpec.describe Inquiry, type: :model do
  describe "バリデーション" do
    it "有効なfactoryを持つこと" do
      inquiry = build(:inquiry)

      expect(inquiry).to be_valid
    end

    it "お問い合わせ種類がなければ無効なこと" do
      inquiry = build(:inquiry, inquiry_type: nil)

      expect(inquiry).not_to be_valid
    end

    it "メールアドレスがなければ無効なこと" do
      inquiry = build(:inquiry, email: nil)

      expect(inquiry).not_to be_valid
    end

    it "メールアドレスの形式が不正なら無効なこと" do
      inquiry = build(:inquiry, email: "invalid-email")

      expect(inquiry).not_to be_valid
    end

    it "お問い合わせ内容がなければ無効なこと" do
      inquiry = build(:inquiry, content: nil)

      expect(inquiry).not_to be_valid
    end

    it "お問い合わせ内容が2000文字以内なら有効なこと" do
      inquiry = build(:inquiry, content: "あ" * 2_000)

      expect(inquiry).to be_valid
    end

    it "お問い合わせ内容が2001文字以上なら無効なこと" do
      inquiry = build(:inquiry, content: "あ" * 2_001)

      expect(inquiry).not_to be_valid
    end
  end

  describe "画像バリデーション" do
    it_behaves_like "画像バリデーション", :inquiry
  end
end