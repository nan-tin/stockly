class CreateGroupUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :group_users, comment: "共有グループ所属情報" do |t|
      t.references :user, null: false, foreign_key: true, comment: "ユーザーID"
      t.references :group, null: false, foreign_key: true, comment: "グループID"
      t.string :display_name, null: false, comment: "共有時の表示名"

      t.timestamps
    end

    add_index :group_users, [:user_id, :group_id], unique: true
  end
end
