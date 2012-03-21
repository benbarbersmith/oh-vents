class EventsController < ApplicationController
  before_filter :authenticate, :only => [:new, :edit, :create, :update, :index, :cancel, :destroy]
  before_filter :correct_user, :only => [:edit, :update, :cancel, :destroy]

  include ApplicationHelper

  def new 
    @title = "New Event"
    @event = Event.new
  end

  def show
    @event = Event.find(params[:id])
    if @event.publicrsvp == false then
      redirect_to("/events/public", :notice => "That event is private. Sorry!") unless current_user?(@event.user)
    end
    @title = @event.name
  end

  def create
    @event = current_user.events.build(params[:event])
    if @event.save
      flash[:success] = "Your event #{@event.name} was created successfully!"
      redirect_to @event
    else
      @title = "New Event"
      render 'new'
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:success] = "Event updated."
      redirect_to @event
    else
      @title = "Edit event"
      render 'edit'
    end
  end

  def edit
    @event = Event.find(params[:id])
    @title = "Edit event"
  end

  def index
    @title = "My events"
    @user = current_user
    @events = @user.events.where("start_date >= :time", :time => DateTime.now).order("start_date").paginate(:page => params[:page], :per_page => 20)
    @other_events = @user.events.where("start_date < :time", :time => DateTime.now).order("start_date").paginate(:page => params[:page], :per_page => 20)
    @time = "Upcoming"
    @other = "Past"
  end

  def past_index
    index
    @other, @time = @time, @other 
    @other_events, @events = @events, @other_events
    render('index')
  end

  def public_index
    @title = "Public Events"
    @public = true
    @events = Event.where("start_date >= :time AND publicrsvp = true", :time => DateTime.now).order("start_date").paginate(:page => params[:page], :per_page => 20)
    @other_events = []
    @time = "Upcoming"
    render('index')
  end

  def cancel
    @title = "Cancel event"
    @event = Event.find(params[:id])
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = "Event cancelled."
    redirect_to events_path
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @event = Event.find(params[:id])
      redirect_to(event_path(@event), :notice => "Only the owner of an event may edit it. Sorry!") unless current_user?(@event.user)
    end

end
