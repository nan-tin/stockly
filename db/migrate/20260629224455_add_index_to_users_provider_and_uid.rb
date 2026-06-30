class AddIndexToUsersProviderAndUid < ActiveRecord::Migration[7.1]
  def change
    add_index :users, [:provider, :uid],
              unique: true,
              name: "index_users_on_provider_and_uid"
  end
end
