class CreateConsumptions < ActiveRecord::Migration[7.1]
  def change
    create_table :consumptions, comment: "消費履歴" do |t|
      t.references :group,
                  null: false,
                  foreign_key: true,
                  comment: "所属共有グループID"

      t.references :category,
                  foreign_key: true,
                  null: true,
                  comment: "カテゴリーID"

      t.string :name,
              null: false,
              comment: "消費した商品名"

      t.date :consumed_on,
            null: false,
            comment: "消費日"

      t.text :memo,
            comment: "消費時点のメモ"

      t.timestamps
    end
  end
end
