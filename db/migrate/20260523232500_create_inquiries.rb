class CreateInquiries < ActiveRecord::Migration[7.1]
  def change
    create_table :inquiries, comment: "お問い合わせ" do |t|
      t.references :user,
                  null: false,
                  foreign_key: true,
                  comment: "問い合わせユーザーID"

      t.integer :inquiry_type,
                null: false,
                comment: "問い合わせ種類"

      t.string :email,
              null: false,
              comment: "返信先メールアドレス"

      t.text :content,
            null: false,
            comment: "問い合わせ内容"

      t.timestamps
    end
  end
end
