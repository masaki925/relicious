class AddEvalCommunicationToUserReview < ActiveRecord::Migration
  def change
    add_column :user_reviews, :eval_communication, :integer
  end
end
