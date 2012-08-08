class ChangeColumnToUser < ActiveRecord::Migration
  def up
    change_column :users, :provider,     :string,  :null => true
    change_column :users, :provider_uid, :integer, :null => true
    change_column :users, :auth_token,   :string,  :null => true
  end

  def down
    change_column :users, :provider,     :string,  :null => false
    change_column :users, :provider_uid, :integer, :null => false
    change_column :users, :auth_token,   :string,  :null => false
  end
end
