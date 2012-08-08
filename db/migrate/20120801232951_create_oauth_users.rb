class CreateOauthUsers < ActiveRecord::Migration
  def change
    create_table :oauth_users do |t|
      t.string :provider,      null: false
      t.integer :provider_uid, null: false, limit: 8
      t.string :auth_token,    null: false
      t.references :user

      t.timestamps
    end
  end
end
