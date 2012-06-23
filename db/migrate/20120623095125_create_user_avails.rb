class CreateUserAvails < ActiveRecord::Migration
  def change
    create_table :user_avails do |t|
      t.references :user
      t.references :area
      t.time :avail_from
      t.time :avail_to
      t.string :option

      t.timestamps
    end
    add_index :user_avails, :user_id
    add_index :user_avails, :area_id
  end
end
