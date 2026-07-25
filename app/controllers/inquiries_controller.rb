class InquiriesController < ApplicationController
  before_action :authenticate_user!

  def new
    @inquiry = current_user.inquiries.build(
      email: current_user.email
    )
  end

  def create
    @inquiry = current_user.inquiries.build(inquiry_params)

    if @inquiry.save
      redirect_to thanks_inquiries_path
    else
      render :new, status: :unprocessable_content
    end
  end

  def thanks
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

