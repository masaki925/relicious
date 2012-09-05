class MeetupComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :meetup
  attr_accessible :body

  validates :user_id,   :presence => true
  validates :meetup_id, :presence => true
  validates :body,      :presence => true

  def self.new_without_mass_asign(params, user)
    mc = self.new(params)
    mc.user_id = user.id
    return mc
  end
end
