class CreateJoinTableGroupsPermissions < ActiveRecord::Migration[8.1]
  def change
    create_join_table :groups, :permissions do |t|
      # t.index [:group_id, :permission_id]
      # t.index [:permission_id, :group_id]
    end
  end
end
