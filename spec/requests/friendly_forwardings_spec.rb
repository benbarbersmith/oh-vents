require 'spec_helper'

describe "FriendlyForwardings" do

  it "should forward to to the edit event page after signin from edit" do
    event = Factory(:full_event)
    visit root_url
    session[:user_id] = event.user.id
    visit edit_event_path(event)
    response.should render_template('events/edit')
  end

  it "should forward to to the new event page after signin from new" do
    visit new_event_path
    response.should render_template('events/new')
  end

end
