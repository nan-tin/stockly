require "rails_helper"

RSpec.describe "GroupSettings", type: :request do
  let(:user) { create(:user) }

  describe "GET /group_settings" do
    context "ログインしている場合" do
      before do
        sign_in user
      end

      it "正常に表示されること" do
        get group_settings_path

        expect(response).to have_http_status(:success)
      end
    end

    context "ログインしていない場合" do
      it "ログイン画面へリダイレクトされること" do
        get group_settings_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /group_settings/regenerate_invite_code" do
    context "オーナーの場合" do
      before do
        sign_in user
      end

      it "招待コードが変更されること" do
        group = user.groups.first
        old_invite_code = group.invite_code

        patch regenerate_invite_code_group_settings_path

        expect(response).to redirect_to(group_settings_path)
        expect(group.reload.invite_code).not_to eq(old_invite_code)
      end
    end

    context "一般メンバーの場合" do
      let(:owner) { create(:user) }
      let(:group) { owner.groups.first }
      let(:member) { create(:user) }

      before do
        member.groups.first.destroy!

        group.group_users.create!(
          user: member,
          display_name: member.email
        )

        sign_in member
      end

      it "招待コードを変更できないこと" do
        old_invite_code = group.invite_code

        patch regenerate_invite_code_group_settings_path

        expect(response).to redirect_to(group_settings_path)
        expect(group.reload.invite_code).to eq(old_invite_code)
      end
    end
  end

  describe "DELETE /group_settings/leave" do
    let(:owner) { create(:user) }
    let(:shared_group) { owner.groups.first }
    let(:member) { create(:user) }

    before do
      member.groups.first.destroy!

      shared_group.group_users.create!(
        user: member,
        display_name: member.email
      )
    end

    context "一般メンバーの場合" do
      before do
        sign_in member
      end

      it "共有グループから退出して個人グループが作成されること" do
        expect do
          delete leave_group_settings_path
        end.to change(Group, :count).by(1)

        expect(response).to redirect_to(settings_path)

        expect(shared_group.reload.users).not_to include(member)

        personal_group = member.reload.groups.first

        expect(personal_group.owner).to eq(member)
        expect(personal_group.users).to contain_exactly(member)
        expect(personal_group.shopping_list).to be_present
        expect(personal_group.categories.pluck(:name)).to include("冷蔵庫")
      end
    end

    context "オーナーの場合" do
      before do
        sign_in owner
      end

      it "退出できないこと" do
        expect do
          delete leave_group_settings_path
        end.not_to change(Group, :count)

        expect(response).to redirect_to(group_settings_path)
        expect(shared_group.reload.users).to include(owner)
      end
    end
  end

  describe "DELETE /group_settings/disband" do
    let(:owner) { create(:user) }
    let(:shared_group) { owner.groups.first }
    let(:member) { create(:user) }

    before do
      member.groups.first.destroy!

      shared_group.group_users.create!(
        user: member,
        display_name: member.email
      )
    end

    context "オーナーの場合" do
      before do
        sign_in owner
      end

      it "共有グループを削除して全メンバーに個人グループを作成すること" do
        shared_group_id = shared_group.id

        expect do
          delete disband_group_settings_path
        end.to change(Group, :count).by(1)

        expect(response).to redirect_to(settings_path)
        expect(Group.exists?(shared_group_id)).to be(false)

        owner_personal_group = owner.reload.groups.first
        member_personal_group = member.reload.groups.first

        expect(owner_personal_group.owner).to eq(owner)
        expect(owner_personal_group.users).to contain_exactly(owner)
        expect(owner_personal_group.shopping_list).to be_present
        expect(owner_personal_group.categories.pluck(:name)).to include("冷蔵庫")

        expect(member_personal_group.owner).to eq(member)
        expect(member_personal_group.users).to contain_exactly(member)
        expect(member_personal_group.shopping_list).to be_present
        expect(member_personal_group.categories.pluck(:name)).to include("冷蔵庫")
      end
    end

    context "一般メンバーの場合" do
      before do
        sign_in member
      end

      it "共有グループを解散できないこと" do
        expect do
          delete disband_group_settings_path
        end.not_to change(Group, :count)

        expect(response).to redirect_to(group_settings_path)
        expect(Group.exists?(shared_group.id)).to be(true)
      end
    end
  end

  describe "GET /group_settings/edit_display_name" do
    before do
      sign_in user
    end

    it "表示名編集画面を正常に表示すること" do
      get edit_display_name_group_settings_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /group_settings/patch_display_name" do
    before do
      sign_in user
    end

    context "有効な表示名の場合" do
      it "自分の表示名を変更すること" do
        group_user = user.group_users.first

        patch update_display_name_group_settings_path,
              params: {
                group_user: {
                  display_name: "ろん"
                }
              }

        expect(response).to redirect_to(group_settings_path)
        expect(group_user.reload.display_name).to eq("ろん")
      end
    end

    context "表示が空の場合" do
      it "変更されず編集画面を再表示すること" do
        group_user = user.group_users.first
        old_display_name = group_user.display_name

        patch update_display_name_group_settings_path,
                params: {
                  group_user: {
                    display_name: ""
                  }
                }

        expect(response).to have_http_status(:unprocessable_content)
        expect(group_user.reload.display_name).to eq(old_display_name)
      end
    end
  end
end
