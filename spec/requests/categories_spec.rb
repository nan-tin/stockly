require "rails_helper"

RSpec.describe "Categories", type: :request do
  let(:user) { create(:user) }
  let(:group) { user.groups.first }

  before do
    sign_in user
  end

  describe "GET /categories" do
    it "正常にレスポンスが返ること" do
      get categories_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /categories" do
    it "カテゴリーを作成できること" do
      expect {
        post categories_path, params: {
          category: {
            name: "食品"
          }
        }
      }.to change(Category, :count).by(1)

      expect(response).to redirect_to(settings_path)
    end
  end

  describe "PATCH /categories/:id" do
    it "カテゴリーを更新できること" do
      category = create(:category, group: group, name: "食品")

      patch category_path(category), params: {
        category: {
          name: "日用品"
        }
      }

      expect(response).to redirect_to(settings_path)
      expect(category.reload.name).to eq "日用品"
    end
  end

  describe "DELETE /categories/:id" do
    it "カテゴリーを削除できること" do
      category = create(:category, group: group)

      expect {
        delete category_path(category)
      }.to change(Category, :count).by(-1)

      expect(response).to redirect_to(settings_path)
    end
  end
end


  