class InquiryMailer < ApplicationMailer
  def notification(inquiry)
    @inquiry = inquiry
    @user = inquiry.user

    attach_image if @inquiry.image.attached?

    mail(
      to: ENV.fetch(
        "INQUIRY_ADMIN_EMAIL",
        "admin@example.com"
      ),
      reply_to: @inquiry.email,
      subject: "【Stockly】お問い合わせを受信しました"
    )
  end

  private

  def attach_image
    attachments[@inquiry.image.filename.to_s] = {
      mime_type: @inquiry.image.content_type,
      content: @inquiry.image.download
    }
  end
end