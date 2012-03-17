require 'spec_helper'

describe "Events" do

  describe "creation" do

    describe "failure" do
      it "should not make a new event" do
        lambda do
          visit new_event_path
          fill_in "Name", :with => ""
          click_button
          response.should render_template('events/new')
          response.should have_selector("h4.alert-heading")
        end.should_not change(Event, :count)
      end

    end

    describe "success" do
      it "should make a new event" do
        lambda do
          visit new_event_path
          fill_in :name, :with => "Mermaid Riding"
          fill_in :location, :with => "On a boat"
          fill_in :details, :with => "Which seat shall I take?"
          click_button
          response.should render_template('events/show')
          response.should have_selector("div.alert-success", :content => "created successfully")
        end.should change(Event, :count).by(1)
      end

    end

  end

end
