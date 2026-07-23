class AddOwnerToGroups < ActiveRecord::Migration[7.1]
  def up
    add_reference :groups,
                  :owner,
                  foreign_key: { to_table: :users }

    execute <<~SQL
      UPDATE groups
      SET owner_id = (
        SELECT group_users.user_id
        FROM group_users
        WHERE group_users.group_id = groups.id
        ORDER BY group_users.created_at ASC, group_users.id ASC
        LIMIT 1
      )
      WHERE owner_id IS NULL;
    SQL

    groups_without_owner = select_value(<<~SQL).to_i
      SELECT COUNT(*)
      FROM groups
      WHERE owner_id IS NULL;
    SQL

    if groups_without_owner.positive?
      raise ActiveRecord::MigrationError,
            "オーナーを設定できないグループが#{groups_without_owner}件あります"
    end

    change_column_null :groups, :owner_id, false
  end

  def down
    remove_reference :groups,
                     :owner,
                     foreign_key: { to_table: :users }
  end
end