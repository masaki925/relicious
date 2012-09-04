class AddFixedToMeetup < ActiveRecord::Migration
  def change
    add_column :meetups, :fixed, :boolean
  end
end
