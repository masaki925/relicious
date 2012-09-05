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

  #def get_meetups_except_me(user, size=3)
  #  offset = 0
  #  loop do
  #    Meetup.all(limit: 10, conditions: ['begin_at > ?', Time.now], order: 'id DESC', offset: offset)

  #    break if @recent_meetups_exceptme.size >= 3
  #    recent_meetup_candidates = Meetup.all(limit: 10, conditions: ['begin_at > ?', Time.now], order: 'id DESC', offset: offset)
  #    break if recent_meetup_candidates.size <= 0

  #    recent_meetup_candidates -= @user_meetups
  #    recent_meetup_candidates.each_with_index do |m_cand, idx|
  #      break if idx >= 3
  #      @recent_meetups_exceptme << m_cand
  #    end
  #    offset += 10
  #  end
  #end
end
