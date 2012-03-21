require 'spec_helper'

describe EventsController do
  render_views

  describe "GET 'new'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

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
          response.should have_selector("dd", :class => "start_date", :content => @event.start_date.to_formatted_s(:friendly))
        end

        it "should have an end date if one was given" do
          get :show, :id => @event
          unless @event.end_date.nil?
            response.should have_selector("dd", :class => "end_date", :content => @event.end_date.to_formatted_s(:friendly))
          end
        end

        it "should have a location if one was given" do
          get :show, :id => @event
          unless @event.location.nil?
            response.should have_selector("dd", :class => "location", :content => @event.location)
          end
        end

        it "should have a details if one was given" do
          get :show, :id => @event
          unless @event.details.nil?
            response.should have_selector("dd", :class => "details", :content => @event.details)
          end
        end
        
      end
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

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
        dt = (DateTime.now + 1.hour).change(:hour => (DateTime.now + 1.hour).hour)
        @attr = { :name => "Event", :start_date => dt, :end_date => (dt + 1.hour), :location => "Somewhere", :details => "This is a description." }
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "should create an event" do
        lambda do
          post :create, :event => @attr
        end.should change(Event, :count).by(1)
      end

      it "should redirect to the event show page" do
        post :create, :event => @attr
        response.should redirect_to(event_path(assigns(:event)))
      end

      it "should have a success message" do
        post :create, :event => @attr
        flash[:success].should =~ /was created successfully/i
      end

    end

  end

  describe "GET 'edit'" do
    
    before(:each) do
      @event = Factory(:full_event)
      @user = @event.user
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @event
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @event
      response.should have_selector("title", :content => "Edit event")
    end

  end

  describe "PUT 'update'" do
    
    before(:each) do
      @event = Factory(:full_event)
      @owner = @event.user
      test_sign_in(@owner)
    end

    describe "failure" do

      before(:each) do
        @attr = {:name => "", :start_date => (DateTime.now - 1.days)}
      end

      it "should render the edit page" do
        put :update, :id => @event, :event => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @event, :event => @attr
        response.should have_selector("title", :content => "Edit event")
      end
      
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "Edited Event", :start_date => (DateTime.now + 1.minute) }
      end

      it "should show a success message" do
        put :update, :id => @event, :event => @attr
        flash[:success].should =~ /updated/
      end

      it "should redirect to the event page" do 
        put :update, :id => @event, :event => @attr
        response.should redirect_to(event_path(@event))
      end

      it "should change the event's attributes" do
        put :update, :id => @event, :event => @attr
        @event.reload
        @event.name.should == @attr[:name]
        @event.start_date.to_formatted_s(:friendly).should == @attr[:start_date].to_formatted_s(:friendly)
      end

    end

  end

  describe "GET 'index'" do

    before(:each) do
      @event1 = Factory(:full_event)
      @owner = @event1.user

      @event2, @private_event, @past_event = Factory(:full_event, :name => "And again.", :user => Factory(:other)), Factory(:full_event, :name => 'Super Sekrit', :publicrsvp => false, :user => @owner), Factory(:full_event, :name => "Past Event, Honest.", :start_date => (DateTime.now + 0.5.seconds), :user => @owner)

      @public_events =  [ @event1, @event2]
      @all_events =     [ @event1, @event2, @private_event, @past_event ]
      @private_events = [ @private_event ]

      @other = Factory(:user)

    end

    describe "for non-signed-in users" do

      it "should redirect to the signin page" do
        get :index
        response.should redirect_to(signin_path(:twitter))
      end

    end

    describe "for signed-in users" do

      before(:each) do
        test_sign_in(@owner)
      end

      it "should be successful" do
        get :index
        response.should be_success 
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "My events")
    end

      it "should return only events they own" do
        get :index
        @owner.events.each do |event|
          response.should have_selector("dd", :content => event.name)
        end
        response.should_not have_selector("dd", :content => @event2.name)
      end

      it "should return events in ascending order of start date" do
        get :index
        false # Needs test.
      end

      it "should paginate events" do
        @events = @all_events
        50.times do
          @events << Factory(:full_event, :name => Factory.next(:name), :start_date => Factory.next(:start_date), :user => @owner)
        end

        get :index
        response.should have_selector("div", :class => "pagination")
        response.should have_selector("a", :content => "2")
      end

      it "should have an element for each event" do
        get :index
        @owner.events.each do |event|
          response.should have_selector("dd", :content => event.name)
        end
      end

    end

  end

  describe "DELETE 'destroy'" do
    
    before(:each) do
      @event = Factory(:full_event)
      @owner = @event.user
      @user  = Factory(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @event
        response.should redirect_to(signin_path(:twitter))
      end
    end

    describe "as a non-owner user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @event
        response.should redirect_to(event_path(@event))
      end
    end

    describe "as an owner" do

      before(:each) do
        test_sign_in(@owner)
      end

      it "should destroy the event" do
        lambda do
          delete :destroy, :id => @event.id
        end.should change(Event, :count).by(-1)
      end

      it "should redirect to the events page" do
        delete :destroy, :id => @event
        response.should redirect_to(events_path)
      end

    end

  end

  describe "authentication of new/create/edit/update pages" do

    before(:each) do
      @owner = Factory(:user)
      @event = Factory(:full_event)
      @attr  = { :name => @event.name, :start_date => (DateTime.now + 1.hours) }
    end

    describe "for non-signed-in users" do

      it "should deny access to 'new'" do
        get :new
        response.should redirect_to(signin_path(:twitter))
      end

      it "should deny access to 'create'" do
        post :create, :event => @attr
        response.should redirect_to(signin_path(:twitter))
      end

      it "should deny access to 'edit'" do
        get :edit, :id => @event
        response.should redirect_to(signin_path(:twitter))
      end

      it "should deny access to 'update'" do
        put :update, :id => @event, :event => @attr
        response.should redirect_to(signin_path(:twitter))
      end

      it "should deny access to 'index'" do
        get :index
        response.should redirect_to(signin_path(:twitter))
      end
    end

    describe "for non-owners" do

      before(:each) do
        @other = Factory(:other)
        test_sign_in(@other)
      end

      it "should deny access to 'edit'" do
        get :edit, :id => @event
        response.should redirect_to(event_path(@event))
      end

      it "should deny access to 'update'" do
        put :update, :id => @event, :event => @attr
        response.should redirect_to(event_path(@event))
      end

    end

  end

end

