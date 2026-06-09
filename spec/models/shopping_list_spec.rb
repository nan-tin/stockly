require "rails_helper"

RSpec.describe ShoppingList, type: :model do
  describe "アソシエーション" do
    it "groupに属すること" do
      shopping_list = build(:shopping_list)

      expect(shopping_list.group).to be_present
    end
  end
end