class Language < ActiveRecord::Base
  attr_accessible :code, :name

  has_many :user_languages
end
