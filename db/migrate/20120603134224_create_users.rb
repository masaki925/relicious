class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider, :null => false
      t.integer :provider_uid, :null => false, :limit => 8
      t.string :screen_name
      t.string :name, :null => false
      t.string :email, :unique => true
      t.datetime :birthday
      t.text :introduction
      t.string :education
      t.string :work
      t.string :auth_token, :null => false
      t.string :device_token

      t.timestamps
    end
  end
end
