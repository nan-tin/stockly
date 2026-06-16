class AddGuestTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, 
               :guest_token, 
               :string, 
               comment: "ゲストログイン用の識別トークン"
               
    add_index :users, :guest_token, unique: true
  end
end
