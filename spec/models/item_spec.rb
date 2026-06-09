require "rails_helper"

RSpec.describe Item, type: :model do
  describe "バリデーション" do
    it "有効なfactoryを持つこと" do
      item = build(:item)

      expect(item).to be_valid
    end

    it "名前がなければ無効なこと" do\
      item = build(:item, name: nil)

      expect(item).not_to be_valid
    end

    it "在庫数が0以上なら有効なこと" do
      item = build(:item, quantity: 0)

      expect(item).to be_valid
    end

    it "在庫数がマイナスなら無効なこと" do
      item = build(:item, quantity: -1)

      expect(item).not_to be_valid
    end
  end
end