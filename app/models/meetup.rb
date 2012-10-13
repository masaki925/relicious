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

  def self.find_with_conditions(user, params)
    meetups = Meetup.order(:updated_at).reverse_order

    # exceptme の場合、ユーザが選べない条件
    public_only = true
    fixed       = true

    # 自分のmeetup のみ
    if params[:about] && params[:about] == 'me'
      params[:fixed] ? ( fixed = params[:fixed] ) : ( fixed = false )
      public_only = false

      meetups = meetups.joins(:user_meetup_permissions).where('user_meetup_permissions.user_id = ?', user.id)

      if params[:status]
        if [ MEETUP_STATUS_INVITED, MEETUP_STATUS_ATTEND, MEETUP_STATUS_DECLINED ].include? params[:status].to_i
          meetups = meetups.joins(:user_meetup_permissions).where('status = ?', params[:status])
        end
      end
    else
      # meetups except the user
      meetups = meetups.joins( :user_meetup_permissions ).group( "user_meetup_permissions.meetup_id" ).having(
        "COUNT(*) = SUM( CASE WHEN user_meetup_permissions.user_id = #{user.id} THEN 0 ELSE 1 END)" )
    end

    meetups = meetups.where( 'fixed = ?', fixed ) if fixed
    meetups = meetups.where( 'public = ?', true ) if public_only

    meetups
  end
end
