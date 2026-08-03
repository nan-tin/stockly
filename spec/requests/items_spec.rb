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

     context "別グループのカテゴリーIDを送信した場合" do
      let!(:other_user) { create(:user) }
      let!(:other_category) do
        other_user.groups.first.categories.create!(name: "他グループ")
      end

      it "アイテムを作成できない" do
        expect do
          post items_path, params: {
            item: {
              category_id: other_category.id,
              name: "不正なアイテム",
              quantity: 1,
              purchased_at: Date.current,
              expired_at: "",
              memo: ""
            }
          }
        end.not_to change(Item, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include(
          "カテゴリーは現在のグループに存在しません"
        )
      end
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

    context "別グループのカテゴリーIDを送信した場合" do
      let!(:item) do
        create(
          :item,
          group: group,
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

      it "アイテムを更新できない" do
        original_category_id = item.category_id
        original_name = item.name

        patch item_path(item), params: {
          item: {
            category_id: other_category.id,
            name: "変更後の名前",
            quantity: item.quantity,
            purchased_at: item.purchased_at,
            expired_at: item.expired_at,
            memo: item.memo
          }
        }

        item.reload

        expect(response).to have_http_status(:unprocessable_content)
        expect(item.category_id).to eq(original_category_id)
        expect(item.name).to eq(original_name)
        expect(response.body).to include(
          "カテゴリーは現在のグループに存在しません"
        )
      end
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

  describe "GET /items 検索" do
    it "キーワードに一致するアイテムが表示されること" do
      create(:item, group: group, category: category, name: "牛乳")
      create(:item, group: group, category: category, name: "卵")

      get items_path, params: { keyword: "牛" }
      
      expect(response.body).to include "牛乳"
      expect(response.body).not_to include "卵"
    end
  end

  describe "DELETE /items/bulk_destroy" do
    it "選択したアイテムを一括削除できること" do
      item1 = create(:item, group: group, category: category)
      item2 = create(:item, group: group, category: category)

      expect {
        delete bulk_destroy_items_path, params: {
          item_ids: [item1.id, item2.id]
        }
      }.to change(Item, :count).by(-2)

      expect(response).to redirect_to(items_path)
    end
  end

  describe "PATCH /items/:id/consume" do
    it "アイテムを消費履歴へ移動できること" do
      item = create(
        :item,
        group: group,
        category: category,
        name: "牛乳",
        quantity: 2
      )

      expect {
        patch consume_item_path(item)
      }.to change(Consumption, :count).by(1)
       .and change(Item, :count).by(-1)

      expect(response).to redirect_to(items_path)

      consumption = Consumption.last

      expect(consumption.item_name).to eq "牛乳"
      expect(consumption.quantity).to eq 2
    end
  end
end


  