require "rails_helper"

RSpec.describe "Items", type: :request do
  let(:user) { create(:user) }
  let(:group) { user.groups.first }
  let(:category) { create(:category, group: group) }

  before do
    sign_in user
  end

  describe "GET /items" do
    it "正常にレスポンスが返ること" do
      get items_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /items" do
    it "アイテムを作成できること" do
      expect {
        post items_path, params: {
          item: {
            category_id: category.id,
            name: "牛乳",
            quantity: 1
          }
        }
      }.to change(Item, :count).by(1)

      expect(response).to redirect_to(items_path)
    end
  end

  describe "PATCH /items/:id" do
    it "アイテムを更新できること" do
      item = create(
        :item,
        group: group,
        category: category,
        name: "牛乳"
      )

      patch item_path(item), params: {
        item: {
          name: "豆乳" 
        }
      }

      expect(response).to redirect_to(items_path)
      expect(item.reload.name).to eq "豆乳"
    end
  end

  describe "DELETE /items/:id" do
    it "アイテムを削除できること" do
      item = create(
        :item,
        group: group,
        category: category
      )

      expect {
        delete item_path(item)
      }.to change(Item, :count).by(-1)

      expect(response).to redirect_to(items_path)
    end
  end
end


  