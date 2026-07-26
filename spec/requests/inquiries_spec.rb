require "rails_helper"

RSpec.describe "Inquiries", type: :request do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }

  before do
    clear_enqueued_jobs
    clear_performed_jobs
    sign_in user
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe "GET /inquiries" do
    it "正常にレスポンスが返ること" do
      get new_inquiry_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /inquiries/thanks" do
    it "正常にレスポンスが返ること" do
      get thanks_inquiries_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /inquiries" do
    context "入力内容が正常な場合" do
      let(:valid_params) do
        {
          inquiry: {
            inquiry_type: "bug",
            email: "test@example.com",
            content: "テスト問い合わせ中です"
          }
        }
      end

      it "お問い合わせを作成できること" do
        expect {
          post inquiries_path, params: valid_params
        }.to change(Inquiry, :count).by(1)
      end

      it "サンクスページへリダイレクトされること" do
        post inquiries_path, params: valid_params

        expect(response).to redirect_to(thanks_inquiries_path)
      end

      it "管理者宛てメールの送信ジョブを登録すること" do
        expect {
          post inquiries_path, params: valid_params
        }.to have_enqueued_mail(
          InquiryMailer,
          :notification
        )
      end
    end

    context "入力内容が不正な場合" do
      let(:invalid_params) do
        {
          inquiry: {
            inquiry_type: "",
            email: "",
            content: ""
          }
        }
      end

      it "お問い合わせが作成されないこと" do
        expect {
          post inquiries_path, params: invalid_params
        }.not_to change(Inquiry, :count)
      end

      it "ステータス422で入力画面を再表示すること" do
        post inquiries_path, params: invalid_params

        expect(response).to have_http_status(:unprocessable_content)
      end

      it "メール送信ジョブを登録しないこと" do
        expect {
          post inquiries_path, params: invalid_params
        }.not_to have_enqueued_mail(
          InquiryMailer,
          :notification
        )
      end
    end
  end
end