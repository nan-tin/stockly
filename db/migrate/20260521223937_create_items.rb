class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items, comment: "在庫アイテム" do |t|
      t.references :group, 
                   null: false, 
                   foreign_key: true,
                   comment: "所属共有グループID"

      t.references :category, 
                   null: false, 
                   foreign_key: true,
                   comment: "カテゴリーID"

      t.string :name,
               null:false,
               comment: "商品名"

      t.integer :quantity,
                null: false,
                default: 0,
                comment: "在庫数"

      t.date :purchased_at,
             comment: "購入日"

      t.date :expired_at,
             comment: "期限日"

      t.text :memo,
             comment: "メモ"

      t.timestamps
    end
  end
end
