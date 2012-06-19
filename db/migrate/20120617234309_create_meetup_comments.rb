class CreateMeetupComments < ActiveRecord::Migration
  def change
    create_table :meetup_comments do |t|
      t.references :user
      t.references :meetup
      t.text :body

      t.timestamps
    end
    add_index :meetup_comments, :user_id
    add_index :meetup_comments, :meetup_id
  end
end
