class SettingsController < ApplicationController
  before_action :authenticate_user!
  
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

    redirect_to settings_path, notice: "データをすべて削除しました"
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed
    redirect_to settings_path, alert: "データの削除に失敗しました"
  end

  def destroy_account
    user = current_user
    groups = user.groups.to_a

    ActiveRecord::Base.transaction do
      groups.each(&:destroy!)
      user.destroy!
    end

    redirect_to login_path, notice: "アカウントを削除しました"
  rescue ActiveRecord::RecordNotDestroyed
    redirect_to settings_path, alert: "アカウントの削除に失敗しました"
  end
end
