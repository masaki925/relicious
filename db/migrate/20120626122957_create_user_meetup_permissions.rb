class CreateUserMeetupPermissions < ActiveRecord::Migration
  def change
    create_table :user_meetup_permissions do |t|
      t.references :user
      t.references :meetup

      t.timestamps
    end
    add_index :user_meetup_permissions, :user_id
    add_index :user_meetup_permissions, :meetup_id
  end
end
