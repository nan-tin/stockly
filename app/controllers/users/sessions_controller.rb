class Users::SessionsController < ApplicationController
  def guest_sign_in
    user = User.guest

    sign_in user

    redirect_to items_path,
                notice: "ゲストユーザーとしてログインしました"
  end
end