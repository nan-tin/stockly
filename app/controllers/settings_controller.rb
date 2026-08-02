class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_group_owner, only: :destroy_data

  def index
    @categories = current_group.categories.order(:created_at)
  end

  def destroy_data
    ActiveRecord::Base.transaction do
      current_group.items.find_each(&:destroy!)
      current_group.shopping_items.find_each(&:destroy!)
      current_group.consumptions.find_each(&:destroy!)
      current_group.categories.find_each(&:destroy!)

      current_group.categories.create!(name: "冷蔵庫")
    end

    redirect_to settings_path,
                notice: "データをすべて削除しました"
  rescue ActiveRecord::RecordInvalid,
         ActiveRecord::RecordNotDestroyed
    redirect_to settings_path,
                alert: "データの削除に失敗しました"
  end

  def destroy_account
    user = current_user
    group = current_group

    if group.owner == user && group.users.many?
      redirect_to settings_path,
                  alert: "共有グループのオーナーは、先にグループを解散してください"
      return
    end

    ActiveRecord::Base.transaction do
      if group.owner == user
        # 個人グループの場合
        group.destroy!
      else
        # 共有グループの一般メンバーの場合
        group.group_users.find_by!(user: user).destroy!
      end

      user.destroy!
    end

    redirect_to login_path,
                notice: "アカウントを削除しました"
  rescue ActiveRecord::RecordNotFound,
         ActiveRecord::RecordInvalid,
         ActiveRecord::RecordNotDestroyed
    redirect_to settings_path,
                alert: "アカウントの削除に失敗しました"
  end

  private

  def require_group_owner
    return if current_group.owner == current_user

    redirect_to settings_path,
                alert: "オーナーのみ操作できます"
  end
end