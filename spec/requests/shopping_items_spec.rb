require "rails_helper"

RSpec.describe "ShoppingItems", type: :request do
  let(:user) { create(:user) }
  let(:group) { user.groups.first }
  let(:shopping_list) { group.shopping_list }
  let(:category) { create(:category, group: group) }

  before do
    sign_in user
  end

  describe "GET /shopping_items" do
    it "正常にレスポンスが返ること" do
      get shopping_items_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /shopping_items" do
    it "買う物を作成できること" do
      expect {
        post shopping_items_path, params: {
          shopping_item: {
            category_id: category.id,
            name: "牛乳",
            quantity: 1,
            memo: "テスト用メモ"
          }
        }
      }.to change(ShoppingItem, :count).by(1)

      expect(response).to redirect_to(shopping_items_path)
    end

    context "別グループのカテゴリーIDを送信した場合" do
      let!(:other_user) { create(:user) }
      let!(:other_category) do
        other_user.groups.first.categories.create!(name: "他グループ")
      end

      it "買うものを作成できない" do
        expect do
          post shopping_items_path, params: {
            shopping_item: {
              category_id: other_category.id,
              name: "不正な買うもの",
              quantity: 1,
              memo: ""
            }
          }
        end.not_to change(ShoppingItem, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include(
          "カテゴリーは現在のグループに存在しません"
        )
      end
    end
  end

  describe "PATCH /shopping_items/:id" do
    it "買う物を更新できること" do
      shopping_item = create(
        :shopping_item,
        shopping_list: shopping_list,
        category: category,
        name: "牛乳"
      )

      patch shopping_item_path(shopping_item), params: {
        shopping_item: {
          name: "豆乳"
        }
      }

      expect(response).to redirect_to(shopping_items_path)
      expect(shopping_item.reload.name).to eq "豆乳"
    end

    context "別グループのカテゴリーIDを送信した場合" do
      let!(:shopping_item) do
        create(
          :shopping_item,
          shopping_list: shopping_list,
          category: category,
          name: "牛乳"
        )
      end

      let!(:other_user) { create(:user) }

      let!(:other_category) do
        other_user.groups.first.categories.create!(
          name: "他グループ"
        )
      end

      it "買うものを更新できない" do
        original_category_id = shopping_item.category_id
        original_name = shopping_item.name

        patch shopping_item_path(shopping_item), params: {
          shopping_item: {
            category_id: other_category.id,
            name: "変更後の名前",
            quantity: shopping_item.quantity,
            memo: shopping_item.memo
          }
        }

        shopping_item.reload

        expect(response).to have_http_status(:unprocessable_content)
        expect(shopping_item.category_id).to eq(original_category_id)
        expect(shopping_item.name).to eq(original_name)
        expect(response.body).to include(
          "カテゴリーは現在のグループに存在しません"
        )
      end
    end
  end

  describe "DELETE /shopping_items/:id" do
    it "買う物を削除できること" do
      shopping_item = create(
        :shopping_item,
        shopping_list: shopping_list,
        category: category,
      )

      expect {
        delete shopping_item_path(shopping_item)
      }.to change(ShoppingItem, :count).by(-1)

      expect(response).to redirect_to(shopping_items_path)
    end
  end

  describe "PATCH /shopping_items/:id/purchase" do
    it "買う物を在庫に追加し、買うものリストから削除できること" do
      shopping_item = create(
        :shopping_item,
        shopping_list: shopping_list,
        category: category,
        name: "牛乳",
        quantity: 2,
        memo: "テスト用メモ" 
      )

      expect {
        patch purchase_shopping_item_path(shopping_item)
      }.to change(Item, :count).by(1)
      .and change(ShoppingItem, :count).by(-1)

      expect(response).to redirect_to(shopping_items_path)

      item = Item.last
      expect(item.name).to eq "牛乳"
      expect(item.quantity).to eq 2
      expect(item.memo).to eq "テスト用メモ"
    end
  end
end



  




