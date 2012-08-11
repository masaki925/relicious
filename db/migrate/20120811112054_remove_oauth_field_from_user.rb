class RemoveOauthFieldFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :provider
    remove_column :users, :provider_uid
    remove_column :users, :auth_token
  end

  def down
    add_column :users, :auth_token, :string, :null => true
    add_column :users, :provider_uid, :integer, :null => true, :limit => 8
    add_column :users, :provider, :string, :null => true
  end
end
