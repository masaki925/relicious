class CreateUserReviews < ActiveRecord::Migration
  def change
    create_table :user_reviews do |t|
      t.references :user
      t.references :meetup
      t.integer :reviewed_user_id
      t.boolean :recommend
      t.text :about_user
      t.text :about_experience
      t.integer :eval_personal
      t.integer :eval_language
      t.integer :eval_gourmet

      t.timestamps
    end
    add_index :user_reviews, :user_id
    add_index :user_reviews, :meetup_id
    add_index :user_reviews, :reviewed_user_id
  end
end
