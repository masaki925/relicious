class CreateMeetups < ActiveRecord::Migration
  def change
    create_table :meetups do |t|
      t.string :title
      t.references :user
      t.references :area
      t.datetime :begin_at
      t.datetime :end_at
      t.boolean :public

      t.timestamps
    end
    add_index :meetups, :user_id
  end
end
