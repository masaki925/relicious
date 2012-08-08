class AddSkillToUserLanguage < ActiveRecord::Migration
  def change
    add_column :user_languages, :skill, :string
  end
end
