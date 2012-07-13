class AddFavoriteFoodToUser < ActiveRecord::Migration
  def change
    add_column :users, :favorite_food, :string
    add_column :users, :ng_food, :string
  end
end
