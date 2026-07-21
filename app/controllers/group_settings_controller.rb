class GroupSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user

  def index
    @group = current_group
    @members = @group.users
  end

  def join
  end

  def join_group
    invite_code = params[:invite_code].to_s.strip.downcase
    joining_group = Group.find_by(invite_code: invite_code)

    if joining_group.nil?
      flash.now[:alert] = "招待コードが見つかりません"
      return render :join, status: :unprocessable_entity
    end

    if joining_group == current_group
      flash.now[:alert] = "現在所属しているグループの招待コードです"
      return render :join, status: :unprocessable_entity
    end

    unless personal_group?
      flash.now[:alert] = "共有中のグループから別のグループには参加できません"
      return render :join, status: :unprocessable_entity
    end

    unless current_group_empty?
      flash.now[:alert] = "在庫などのデータが残っているため参加できません"
      return render :join, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      current_group.destroy!
      joining_group.group_users.create!(
        user: current_user,
        display_name: current_user.email
        )
    end

    redirect_to group_settings_path,
                notice: "共有グループに参加しました"
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed
    flash.now[:alert] = "グループへの参加に失敗しました"
    render :join, status: :unprocessable_entity
  end

  private

  def personal_group?
    current_group.owner == current_user &&
      current_group.users.one?
  end

  def current_group_empty?
    current_group.items.none? &&
      current_group.shopping_items.none? &&
      current_group.consumptions.none?
  end

  def reject_guest_user
    return unless current_user.guest?

    redirect_to settings_path,
                alert: "ゲストユーザーは共有機能を利用できません"
  end
end