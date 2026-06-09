require "rails_helper"

RSpec.describe Consumption, type: :model do
  describe "バリデーション" do
    it "有効なfactoryを持つこと" do
      consumption = build(:consumption)

      expect(consumption).to be_valid
    end

    it "カテゴリー名がなければ無効なこと" do
      consumption = build(:consumption, category_name: nil)

      expect(consumption).not_to be_valid
    end

    it "商品名がなければ無効なこと" do
      consumption = build(:consumption, item_name: nil)

      expect(consumption).not_to be_valid
    end

    it "消費日時がなければ無効なこと" do
      consumption = build(:consumption, consumed_at: nil)

      expect(consumption).not_to be_valid
    end

    it "数量が1以上なら有効なこと" do
      consumption = build(:consumption, quantity: 1)

      expect(consumption).to be_valid
    end

    it "数量が0なら無効なこと" do
      consumption = build(:consumption, quantity: 0)

      expect(consumption).not_to be_valid
    end
  end
end
