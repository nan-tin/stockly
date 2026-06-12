require "rails_helper"

RSpec.describe "Consumptions", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /consumptions" do
    it "正常なレスポンスが返ること" do
      get consumptions_path

      expect(response).to have_http_status(:ok)
    end
  end
end