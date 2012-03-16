class EventsController < ApplicationController
  def new 
    @title = "New Event"
  end

  def show
    @event = Event.find(params[:id])
    @title = @event.name
  end
end
