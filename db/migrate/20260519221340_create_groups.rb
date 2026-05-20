class CreateGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :groups, comment: "共有グループ" do |t|
      t.string :invite_code, null: false, comment: "グループ招待コード"

      t.timestamps
    end

    add_index :groups, :invite_code, unique: true
  end
end
