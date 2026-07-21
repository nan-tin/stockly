class AddOwnerToGroups < ActiveRecord::Migration[7.1]
  def up
    add_reference :groups,
                  :owner,
                  foreign_key: { to_table: :users }

    Group.reset_column_information

    Group.find_each do |group|
      owner = group.users.first
      group.update_column(:owner_id, owner.id) if owner
    end

    change_column_null :groups, :owner_id, false
  end

  def down
    remove_reference :groups,
                     :owner,
                     foreign_key: { to_table: :users }
  end
end