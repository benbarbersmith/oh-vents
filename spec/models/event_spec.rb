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

require 'spec_helper'

describe Event do
  before(:each) do
    @user = Factory(:user)
    @attr = { :name => "Example Event", :start_date => DateTime.now() + 1.day}
  end

  it "should create a new instance given valid attributes" do
    @user.events.build(@attr)
  end

  it "should require a name" do
      no_name_event = @user.events.build(@attr.merge(:name => ""))
      no_name_event.should_not be_valid
  end

  it "should require a start date" do
      no_start_event = @user.events.build(@attr.merge(:start_date => nil))
      no_start_event.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a"*51
    long_name_event = @user.events.build(@attr.merge(:name => long_name))
    long_name_event.should_not be_valid
  end

  it "should reject events that are in the past" do
    yesterday = 1.day.ago
    past_event = @user.events.build(@attr.merge(:start_date => yesterday))
    past_event.should_not be_valid
  end

  it "should reject events that finish before they begin" do
    yesterday = 1.day.ago 
    backwards_event = @user.events.build(@attr.merge(:end_date => yesterday))
    backwards_event.should_not be_valid
  end
end
