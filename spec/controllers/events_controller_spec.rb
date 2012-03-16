require 'spec_helper'

describe EventsController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_successful
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "New Event")
    end

  end

  describe "GET 'show'" do

    events = :minimal_event, :full_event
    events.each do |event|
      context "for a #{event}" do

        before(:each) do
          @event = Factory(event)
        end

        it "should be successful" do
          get :show, :id => @event
          response.should be_success
        end

        it "should find the right event" do
          get :show, :id => @event
          assigns(:event).should == @event
        end

        it "should have the right title" do
          get :show, :id => @event
          response.should have_selector("title", :content => @event.name)
        end

        it "should include the event's name" do
          get :show, :id => @event
          response.should have_selector("h1", :class => "eventname", :content => @event.name)
        end

        it "should include a start date" do
          get :show, :id => @event
          response.should have_selector("span", :class => "startdate", :content => @event.startdate.to_formatted_s(:rfc822))
        end

        it "should have an end date if one was given" do
          get :show, :id => @event
          unless @event.enddate.nil?
            response.should have_selector("span", :class => "enddate", :content => @event.enddate.to_formatted_s(:rfc822))
          end
        end

        it "should have a location if one was given" do
          get :show, :id => @event
          unless @event.location.nil?
            response.should have_selector("span", :class => "location", :content => @event.location)
          end
        end

        it "should have a details if one was given" do
          get :show, :id => @event
          unless @event.details.nil?
            response.should have_selector("span", :class => "details", :content => @event.details)
          end
        end
        
      end
    end
  end
end
