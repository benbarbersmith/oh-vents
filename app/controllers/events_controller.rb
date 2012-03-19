class EventsController < ApplicationController
  before_filter :authenticate, :only => [:new, :edit, :create, :update]
  before_filter :correct_user, :only => [:edit, :update]

  include ApplicationHelper

  def new 
    @title = "New Event"
    @event = Event.new
  end

  def show
    @event = Event.find(params[:id])
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

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @event = Event.find(params[:id])
      redirect_to(event_path(@event)) unless current_user?(@event.user)
    end

end
