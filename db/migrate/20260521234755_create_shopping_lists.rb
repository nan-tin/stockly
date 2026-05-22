class CreateShoppingLists < ActiveRecord::Migration[7.1]
  def change
    create_table :shopping_lists, comment: "買い物リスト" do |t|
      t.references :group, 
                   null: false, 
                   foreign_key: true,
                   index: { unique: true },
                   comment: "所属共有グループID"

      t.timestamps
    end
  end
end
