class CreateShoppingItems < ActiveRecord::Migration[7.1]
  def change
    create_table :shopping_items, comment: "買い物アイテム" do |t|
      t.references :shopping_list,
                  null: false,
                  foreign_key: true,
                  comment: "所属買い物リストID"

      t.references :category,
                  null: false,
                  foreign_key: true,
                  comment: "カテゴリーID"

      t.string :name,
              null: false,
              comment: "商品名"

      t.integer :quantity,
                null: false,
                default: 1,
                comment: "購入予定数"

      t.text :memo,
            comment: "メモ"

      t.boolean :is_purchased,
                null: false,
                default: false,
                comment: "購入済みフラグ"

      t.timestamps
    end
  end
end
