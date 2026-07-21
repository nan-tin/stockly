require "rails_helper"

RSpec.describe "GroupSettings", type: :request do
  let(:user) { create(:user) }

  describe "GET /group_settings" do
    context "ログインしている場合" do
      before do
        sign_in user
      end

      it "正常に表示されること" do
        get group_settings_path

        expect(response).to have_http_status(:success)
      end
    end

    context "ログインしていない場合" do
      it "ログイン画面へリダイレクトされること" do
        get group_settings_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end