require "rails_helper"

RSpec.describe InquiryMailer, type: :mailer do
  describe "#notification" do
    let(:admin_email) { "admin@example.com" }

    let(:inquiry) do
      create(
        :inquiry,
        inquiry_type: :bug,
        email: "reply@example.com",
        content: "お問い合わせ本文です"
      )
    end

    let(:mail) do
      described_class.notification(inquiry)
    end

    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch)
        .with("INQUIRY_ADMIN_EMAIL")
        .and_return(admin_email)
    end

    it "管理者宛てに送信されること" do
      expect(mail.to).to eq([admin_email])
    end

    it "問い合わせメールアドレスが返信先に設定されること" do
      expect(mail.reply_to).to eq(["reply@example.com"])
    end

    it "件名が設定されていること" do
      expect(mail.subject).to eq(
        "【Stockly】お問い合わせを受信しました"
      )
    end

    it "本文にお問い合わせ内容が含まれること" do
      expect(mail.html_part.body.decoded)
        .to include("お問い合わせ本文です")

      expect(mail.text_part.body.decoded)
        .to include("お問い合わせ本文です")
    end
  end
end