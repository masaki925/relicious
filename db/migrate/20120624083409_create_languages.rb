class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
    add_index :languages, :code
  end
end