# == Schema Information
#
# Table name: events
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  start_date       :datetime
#  end_date         :datetime
#  location        :string(255)
#  details         :string(255)
#  publicrsvp      :boolean
#  publicguestlist :boolean
#  created_at      :datetime
#  updated_at      :datetime
#

class Event < ActiveRecord::Base
  attr_accessible :name, :start_date, :end_date, :location, :details
  belongs_to :user

  validates :user_id,   :presence => true
  validates :name,      :presence => true,
                        :length   => { :maximum => 50 }
  validates :start_date, :presence => true
  validate  :is_in_future
  validate  :is_after_start_date

  validates_uniqueness_of :name, :scope => [:start_date, :location], :message => "has been used already for an event at that start date and location"

  before_save :default_values

  def is_in_future 
    unless start_date.nil?
      errors.add(:start_date, "must be in the future") unless self.start_date.future?
    end
  end

  def is_after_start_date
    unless end_date.nil?
      errors.add(:end_date, "must be after start date") if (self.start_date > self.end_date)
    end
  end

  def publicrsvp?
    return :publicrsvp
  end

  def publicguestlist?
    return :publicguestlist
  end

  private
    def default_values
      self.publicrsvp      ||= true
      self.publicguestlist ||= true
    end
end
