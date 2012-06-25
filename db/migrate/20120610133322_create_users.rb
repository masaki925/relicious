class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name,          :null => false
      t.string :screen_name
      t.string :email,           :unique => true
      t.string :provider,      :null => false
      t.integer :provider_uid, :null => false, :limit => 8
      t.string :auth_token,    :null => false
      t.date :birthday
      t.text :introduction
      t.string :education
      t.string :work
      t.string :gender
      t.string :locale
      t.string :location
      t.text :likes

      t.timestamps
    end
  end
end
