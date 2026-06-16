class AddGuestTokenExpiresAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, 
               :guest_token_expires_at, 
               :datetime,
               comment: "ゲストトークンの有効期限"
  end
end
