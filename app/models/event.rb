# == Schema Information
#
# Table name: events
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  startdate       :datetime
#  enddate         :datetime
#  location        :string(255)
#  details         :string(255)
#  publicrsvp      :boolean
#  publicguestlist :boolean
#  created_at      :datetime
#  updated_at      :datetime
#

class Event < ActiveRecord::Base
  attr_accessible :name, :startdate, :enddate, :location, :details

  validates :name,      :presence => true,
                        :length   => { :maximum => 50 }
  validates :startdate, :presence => true
  validate  :is_in_future
  validate  :is_after_startdate

  before_save :default_values

  def is_in_future 
    unless startdate.nil?
      errors.add(:startdate, 'must be in the future') unless self.startdate.future?
    end
  end

  def is_after_startdate
    unless enddate.nil?
      errors.add(:enddate, 'must be after #{:startdate}') if (self.startdate > self.enddate)
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
