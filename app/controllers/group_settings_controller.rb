class GroupSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user

  before_action :require_group_owner,
                only: %i[regenerate_invite_code disband]
                
  before_action :reject_group_owner,
                only: :leave

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

  def regenerate_invite_code
    current_group.update!(
      invite_code: generate_unique_invite_code
    )

    redirect_to group_settings_path,
                notice: "招待コードを再発行しました"
  rescue ActiveRecord::RecordInvalid
    redirect_to group_settings_path,
                alert: "招待コードの再発行に失敗しました"
  end

  def leave
    leaving_group = current_group

    ActiveRecord::Base.transaction do
      leaving_group.group_users.find_by!(
        user: current_user
      ).destroy!

      current_user.create_personal_group
    end

    redirect_to settings_path,
                notice: "共有グループから退出しました"
  rescue ActiveRecord::RecordNotFound,
        ActiveRecord::RecordInvalid,
        ActiveRecord::RecordNotDestroyed
    redirect_to group_settings_path,
                alert: "共有グループからの退出に失敗しました"
  end

  def disband
    disbanding_group = current_group
    members = disbanding_group.users.to_a

    ActiveRecord::Base.transaction do
      disbanding_group.destroy!

      members.each(&:create_personal_group)
    end

    redirect_to settings_path,
                notice: "共有グループを解散しました"
  rescue ActiveRecord::RecordInvalid,
         ActiveRecord::RecordNotDestroyed
    redirect_to group_settings_path,
                alert: "共有グループの解散に失敗しました"
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

  def require_group_owner
    return if current_group.owner == current_user

    redirect_to group_settings_path,
                alert: "オーナーのみ操作できます"
  end

  def generate_unique_invite_code
    loop do
      invite_code = SecureRandom.hex(4)

      return invite_code unless Group.exists?(invite_code: invite_code)
    end
  end

  def reject_guest_user
    return unless current_user.guest?

    redirect_to settings_path,
                alert: "ゲストユーザーは共有機能を利用できません"
  end

  def reject_group_owner
    return unless current_group.owner == current_user

    redirect_to group_settings_path,
                alert: "オーナーはグループから退出できません"
  end
end