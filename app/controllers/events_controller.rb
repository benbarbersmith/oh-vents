class EventsController < ApplicationController
  def new 
    @title = "New Event"
    @event = Event.new
  end

  def show
    @event = Event.find(params[:id])
    @title = @event.name
  end

  def create
    @event = Event.new(params[:event])
    if @event.save
      flash[:success] = "Your event #{@event.name} was created successfully!"
      redirect_to @event
    else
      @title = "New Event"
      render 'new'
    end
  end

end
