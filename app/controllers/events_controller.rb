class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show]
  before_action :set_events, only: :index

  def index
    respond_to do |format|
      format.html {}
      format.json { render json: @events, each_serializer: EventSerializer }
    end
  end

  def show
  end

  private

  def set_events
    @events = Event.crossing_interval(params[:start], params[:end]) if params[:start]
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
