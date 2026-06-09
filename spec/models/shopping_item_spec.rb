require 'rails_helper'

RSpec.describe ShoppingItem, type: :model do
  describe "バリデーション" do
    it "有効なfactoryを持つこと" do
      shopping_item = build(:shopping_item)

      expect(shopping_item).to be_valid
    end

    it "商品名がなければ無効なこと" do
      shopping_item = build(:shopping_item, name: nil)

      expect(shopping_item).not_to be_valid
    end

    it "購入数が1以上なら有効なこと" do
      shopping_item = build(:shopping_item, quantity: 1)

      expect(shopping_item).to be_valid
    end

    it "購入数が0なら無効なこと" do
      shopping_item = build(:shopping_item, quantity: 0)
      
      expect(shopping_item).not_to be_valid
    end
  end
end