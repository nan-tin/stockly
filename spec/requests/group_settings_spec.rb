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
end