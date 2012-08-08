class UserLanguage < ActiveRecord::Base
  attr_accessible :language_id, :skill, :user_id

  belongs_to :user
  belongs_to :language

  validates :user_id,     presence: true
  validates :language_id, presence: true
  #validates :skill,       presence: true

  validates_uniqueness_of :language_id, :scope => [:user_id]
end
