class AddStatusToUserMeetupPermission < ActiveRecord::Migration
  def change
    add_column :user_meetup_permissions, :status, :integer, limit: 2
  end
end
