require 'spec_helper'

describe EventsController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_successful
    end

    it "should have the right title" do
      get :new
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
          response.should have_selector("span", :class => "start_date", :content => @event.start_date.to_formatted_s(:rfc822))
        end

        it "should have an end date if one was given" do
          get :show, :id => @event
          unless @event.end_date.nil?
            response.should have_selector("span", :class => "end_date", :content => @event.end_date.to_formatted_s(:rfc822))
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

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @attr = {:name => "", :start_date => "", :end_date => "", :location => "", :details => ""}
      end

      it "should not create an event" do
        lambda do
          post :create, :event => @attr
        end.should_not change(Event, :count)
      end

      it "should have the right title" do
        post :create, :event => @attr
        response.should have_selector("title", :content => "New Event")
      end

      it "should render the new event page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

    end

    describe "success" do
      before(:each) do
        dt = DateTime.now.change(:hour => (DateTime.now + 1.hour).hour)
        @attr = { :name => "Event", :start_date => dt, :end_date => (dt + 1.hour), :location => "Somewhere", :details => "This is a description." }
      end

      it "should create an event" do
        lambda do
          post :create, :event => @attr
        end.should change(Event, :count).by(1)
      end

      it "should redicrect to the event show page" do
        post :create, :event => @attr
        response.should redirect_to(event_path(assigns(:event)))
      end

      it "should have a success message" do
        post :create, :event => @attr
        flash[:success].should =~ /was created successfully/i
      end

    end

  end

end
