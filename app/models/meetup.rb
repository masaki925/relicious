class Meetup < ActiveRecord::Base
  attr_accessible :public, :title, :area_id, :place, :url, :description, :begin_at, :end_at

  belongs_to :user
  belongs_to :area

  has_many   :meetup_comments, dependent: :destroy
  has_many   :user_meetup_permissions
  has_many   :users, through: :user_meetup_permissions
  has_many   :user_reviews

  validates :user_id,     :presence => true
  validates :title,       :presence => true
  validates_inclusion_of :fixed, :in => [true, false]

  def self.new_without_mass_asign(params, user)
    m = self.new(params)
    m.user_id = user.id
    m.fixed = false
    return m
  end
end
