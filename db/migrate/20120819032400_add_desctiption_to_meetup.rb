class AddDesctiptionToMeetup < ActiveRecord::Migration
  def change
    add_column :meetups, :description, :text
  end
end
