class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :provicer_uid
      t.string :screen_name
      t.string :name
      t.string :email
      t.datetime :birthday
      t.text :introduction
      t.string :education
      t.string :work
      t.string :auth_token
      t.string :device_token

      t.timestamps
    end
  end
end
