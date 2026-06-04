class InquiriesController < ApplicationController
  before_action :authenticate_user!

  def new
    @inquiry = current_user.inquiries.build
  end

  def create
    @inquiry = current_user.inquiries.build(inquiry_params)

    if @inquiry.save
      redirect_to settings_path, notice: "お問い合わせを送信しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(
      :inquiry_type,
      :email,
      :content,
      :image
    )
  end
end

