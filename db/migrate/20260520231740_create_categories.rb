class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories, comment: "カテゴリー" do |t|
      t.references :group, 
                   null: false, 
                   foreign_key: true,
                   comment: "所属共有グループID"

      t.string :name,
               null: false,
               comment: "カテゴリー名"

      t.timestamps
    end

    add_index :categories, [:group_id, :name], unique: true
  end
end
