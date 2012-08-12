class AddNationalityToUser < ActiveRecord::Migration
  def change
    add_column :users, :nationality, :string, :limit => 10
  end
end
