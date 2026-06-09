require "rails_helper"

RSpec.describe Category, type: :model do
  describe "バリデーション" do
    it "有効なFactoryを持つこと" do
      category = build(:category)

      expect(category).to be_valid
    end

    it "名前がなければ無効なこと" do
      category = build(:category, name: nil)

      expect(category).not_to be_valid
    end
  end
end
