require "rails_helper"

RSpec.describe "Settings", type: :request do
  let(:user) { create(:user) }
  let(:group) { user.groups.first }
  let(:shopping_list) { group.shopping_list }

  before do
    sign_in user
  end

  describe "DELETE /settings/data" do
    before do
      category = group.categories.create!(name: "日用品")

      group.items.create!(
        category: category,
        name: "牛乳",
        quantity: 2
      )

      shopping_list.shopping_items.create!(
        category: category,
        name: "卵",
        quantity: 1
      )

      group.consumptions.create!(
        category: category,
        category_name: category.name,
        item_name: "パン",
        consumed_at: Date.current,
        quantity: 1
      )
    end

    it "在庫・買うもの・消費履歴をすべて削除する" do
      delete destroy_data_path

      expect(group.items.reload).to be_empty
      expect(group.shopping_items.reload).to be_empty
      expect(group.consumptions.reload).to be_empty
    end

    it "カテゴリーを冷蔵庫1件に初期化する" do
      delete destroy_data_path

      expect(group.categories.reload.pluck(:name)).to eq(["冷蔵庫"])
    end

    it "ユーザー・グループ・買うものリストを削除しない" do
      expect do
        delete destroy_data_path
      end.not_to change(User, :count)

      expect(User.exists?(user.id)).to be true
      expect(Group.exists?(group.id)).to be true
      expect(ShoppingList.exists?(shopping_list.id)).to be true
    end

    it "設定画面へリダイレクトする" do
      delete destroy_data_path

      expect(response).to redirect_to(settings_path)
      expect(flash[:notice]).to eq("データをすべて削除しました")
    end
  end

  describe "DELETE /settings/account" do
    before do
      category = group.categories.create!(name: "日用品")

      group.items.create!(
        category: category,
        name: "牛乳",
        quantity: 2
      )

      shopping_list.shopping_items.create!(
        category: category,
        name: "卵",
        quantity: 1
      )

      group.consumptions.create!(
        category: category,
        category_name: category.name,
        item_name: "パン",
        consumed_at: Date.current,
        quantity: 1
      )

      user.inquiries.create!(
        inquiry_type: :bug,
        email: user.email,
        content: "テスト"
      )
    end
    
    it "ユーザーと関連データを削除する" do
      expect do
        delete destroy_account_path
      end.to change(User, :count).by(-1)
        .and change(Group, :count).by(-1)
        .and change(GroupUser, :count).by(-1)
        .and change(ShoppingList, :count).by(-1)
        .and change(Category, :count).by(-2)
        .and change(Item, :count).by(-1)
        .and change(ShoppingItem, :count).by(-1)
        .and change(Consumption, :count).by(-1)
        .and change(Inquiry, :count).by(-1)
    end

    it "ログイン画面へリダイレクトする" do
      delete destroy_account_path

      expect(response).to redirect_to(login_path)
      expect(flash[:notice]).to eq("アカウントを削除しました")
    end
  end

  describe "セキュリティと権限の確認" do
    describe "DELETE /settings/data" do
      context "共有グループの一般メンバーの場合" do
        let!(:owner) { create(:user) }
        let!(:member) { create(:user) }
        let!(:shared_group) { owner.groups.first }

        before do
          # member作成時に自動生成された個人グループを削除
          member.groups.first.destroy!

          shared_group.group_users.create!(
            user: member,
            display_name: member.email
          )

          shared_group.items.create!(
            category: shared_group.categories.first,
            name: "共有グループの在庫",
            quantity: 1,
            purchased_at: Date.current
          )

          sign_in member
        end

        it "共有グループのデータを削除できない" do
          expect do
            delete destroy_data_path
          end.not_to change(Item, :count)

          expect(response).to redirect_to(settings_path)
          expect(flash[:alert]).to eq("オーナーのみ操作できます")
        end
      end
    end

    describe "DELETE /settings/account" do
      context "共有グループの一般メンバーの場合" do
        let!(:owner) { create(:user) }
        let!(:member) { create(:user) }
        let!(:shared_group) { owner.groups.first }

        before do
          member.groups.first.destroy!

          shared_group.group_users.create!(
            user: member,
            display_name: member.email
          )

          shared_group.items.create!(
            category: shared_group.categories.first,
            name: "共有グループの在庫",
            quantity: 1,
            purchased_at: Date.current
          )

          sign_in member
        end

        it "本人だけを削除し、共有グループとデータを残す" do
          group_id = shared_group.id
          item_id = shared_group.items.first.id
          owner_id = owner.id
          member_id = member.id

          expect do
            delete destroy_account_path
          end.to change(User, :count).by(-1)
            .and change(GroupUser, :count).by(-1)
            .and change(Group, :count).by(0)
            .and change(Item, :count).by(0)

          expect(User.exists?(member_id)).to be false
          expect(User.exists?(owner_id)).to be true
          expect(Group.exists?(group_id)).to be true
          expect(Item.exists?(item_id)).to be true

          expect(response).to redirect_to(login_path)
          expect(flash[:notice]).to eq("アカウントを削除しました")
        end
      end

      context "共有グループのオーナーの場合" do
        let!(:owner) { create(:user) }
        let!(:member) { create(:user) }
        let!(:shared_group) { owner.groups.first }

        before do
          member.groups.first.destroy!

          shared_group.group_users.create!(
            user: member,
            display_name: member.email
          )

          sign_in owner
        end

        it "グループを解散する前はアカウントを削除できない" do
          owner_id = owner.id
          group_id = shared_group.id

          expect do
            delete destroy_account_path
          end.not_to change(User, :count)

          expect(User.exists?(owner_id)).to be true
          expect(Group.exists?(group_id)).to be true

          expect(response).to redirect_to(settings_path)
          expect(flash[:alert]).to eq(
            "共有グループのオーナーは、先にグループを解散してください"
          )
        end
      end
    end
  end
end