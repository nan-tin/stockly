class AddOmniauthToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, 
               :provider, 
               :string,
               comment: "OAuthプロバイダー"

    add_column :users, 
               :uid, 
               :string,
               comment: "OAuthユーザーID"
  end
end
