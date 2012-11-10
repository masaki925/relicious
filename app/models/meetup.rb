class Meetup < ActiveRecord::Base
  attr_accessible :public, :title, :area_id, :place, :url, :description, :begin_at, :end_at

  belongs_to :user
  belongs_to :area

  has_many   :meetup_comments, dependent: :destroy
  has_many   :user_meetup_permissions
  has_many   :users, through: :user_meetup_permissions
  has_many   :user_reviews

  validates :user_id,     :presence => true
  validates :title,       :presence => true, :length => { :maximum => 60 }
  validates_inclusion_of :fixed, :in => [true, false]

  def self.new_without_mass_asign(params, user)
    m = self.new(params)
    m.user_id = user.id
    m.fixed = false
    return m
  end

  def self.find_user_meetups(user, param)
    meetups = Meetup.order(:updated_at).reverse_order
    fixed   = nil
    status  = MEETUP_STATUS_ATTEND

    param = 'attend' if param.nil?
    case(param)
    when 'attend'
      fixed = true
    when 'pending'
      fixed = false
    when 'invited'
      status = MEETUP_STATUS_INVITED
    when 'declined'
      status = MEETUP_STATUS_DECLINED
    else
      return []
    end

    meetups = meetups.where('fixed = ?', fixed) unless fixed.nil?
    meetups = meetups.where('status = ?', status)
    meetups = meetups.joins(:user_meetup_permissions).where('user_meetup_permissions.user_id = ?', user.id)

    meetups
  end

  def self.find_except(user)
    meetups = Meetup.where('fixed = ? AND public = ?', true, true)

    # meetups except the user
    meetups = Meetup.joins( :user_meetup_permissions ).group( "user_meetup_permissions.meetup_id" ).having(
      "COUNT(*) = SUM( CASE WHEN user_meetup_permissions.user_id = #{user.id} THEN 0 ELSE 1 END)" ).order('meetups.updated_at').reverse_order

    meetups
  end

  def editable?(user)
    UserMeetupPermission.where('meetup_id = ? AND user_id = ? AND status = ?', self.id, user.id, MEETUP_STATUS_ATTEND).first
  end

  def answered?(user)
    UserMeetupPermission.where('meetup_id = ? AND user_id = ? AND ( status = ? OR status = ? )',
                               self.id, user.id, MEETUP_STATUS_ATTEND, MEETUP_STATUS_DECLINED).first
  end
end
