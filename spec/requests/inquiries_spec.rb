require "rails_helper"

RSpec.describe "Inquiries", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /inquiries" do
    it "正常にレスポンスが返ること" do
      get new_inquiry_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /inquiries" do
    it "お問い合わせを作成できること" do
      expect {
        post inquiries_path, params: {
          inquiry: {
            inquiry_type: "bug",
            email: "test@example.com",
            content: "テスト問い合わせです"
          }
        }
      }.to change(Inquiry, :count).by(1)

      expect(response).to redirect_to(settings_path)
    end
  end
end