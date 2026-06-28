require "rails_helper"

RSpec.describe "Consumptions", type: :request do
  let(:user) { create(:user) }
  let(:group) { user.groups.first }
  let(:category) { create(:category, group: group) }


  before do
    sign_in user
  end

  describe "GET /consumptions" do
    it "正常なレスポンスが返ること" do
      get consumptions_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /consumptions" do
    let(:valid_params) do
      {
        consumption: {
          category_id: category.id,
          item_name: "牛乳",
          quantity: 2,
          consumed_at: Date.current,
          memo: "テスト"
        }
      }
    end

    it "消費履歴を作成できること" do
      expect do
        post consumptions_path, params: valid_params
      end.to change(Consumption, :count).by(1)

      expect(response).to redirect_to(
        consumptions_path(
          month: Date.current.strftime("%Y-%m"),
          date: Date.current.strftime("%Y-%m-%d")
        )
      )
    end
  end

  describe "PATCH /consumptions/:id" do
    let(:consumption) do
      create(
        :consumption,
        group: group,
        category: category,
        category_name: category.name,
        item_name: "牛乳",
        quantity: 1,
        consumed_at: Date.current
      )
    end

    let(:update_params) do
      {
        consumption: {
          category_id: category.id,
          item_name: "ヨーグルト",
          quantity: 3,
          consumed_at: Date.current,
          memo: "更新後メモ"
        }
      }
    end

    it "消費履歴を更新できること" do
      patch consumption_path(consumption), params: update_params

      expect(response).to redirect_to(
        consumptions_path(
          month: Date.current.strftime("%Y-%m"),
          date: Date.current.strftime("%Y-%m-%d")
        )
      )

      consumption.reload
      expect(consumption.item_name).to eq "ヨーグルト"
      expect(consumption.quantity).to eq 3
      expect(consumption.memo).to eq "更新後メモ"
    end
  end

  describe "DELETE /consumptions/:id" do
    let!(:consumption) do
      create(
        :consumption,
        group: group,
        category: category, 
        category_name: category.name,
        consumed_at: Date.current
      )
    end

    it "消費履歴を削除できること" do
      expect do
        delete consumption_path(consumption)
      end.to change(Consumption, :count).by(-1)

      expect(response).to redirect_to(
        consumptions_path(
          month: Date.current.strftime("%Y-%m"),
          date: Date.current.strftime("%Y-%m-%d")
        )
      )
    end
  end


end