class Users::SessionsController < ApplicationController
  def guest_sign_in
    user = find_or_create_guest_user

    rotate_guest_token!(user)

    sign_in user

    redirect_to items_path,
                notice: "ゲストユーザーとしてログインしました"
  end

  def login
  end

  private

  def find_or_create_guest_user
    return User.guest if cookies.signed[:guest_token].blank?

    user = User.find_by(
      guest_token: cookies.signed[:guest_token]
    )

    return User.guest if user.blank?
    return User.guest if user.guest_token_expires_at.blank?
    return User.guest if user.guest_token_expires_at.past?

    user
  end
  
  def rotate_guest_token!(user)
    user.update!(
      guest_token: SecureRandom.urlsafe_base64(32),
      guest_token_expires_at: 30.days.from_now
    )

    cookies.permanent.signed[:guest_token] = user.guest_token
  end
end